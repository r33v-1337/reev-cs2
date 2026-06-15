import { definePluginSettings } from "@api/Settings";
import { patcher } from "@api/patcher";
import { findByProps, findByStoreName, findByDisplayName } from "@webpack";
import { React, UserStore } from "@webpack/common";
import { Tooltip } from "@components/Tooltip";

// 1. DEFINE SETTINGS
// This replaces Settings.tsx. Vencord will auto-generate the UI for this.
const settings = definePluginSettings({
    quickAfkMessage: {
        type: "string",
        default: "I am currently AFK, I'll be responding soon!",
        description: "The message to set for your custom status."
    },
    quickAfkEmoji: {
        type: "string",
        default: "🌙",
        description: "The emoji to use for your AFK status."
    }
});

// 2. FIND DISCORD MODULES
// We find these once and store them
const StatusUpdater = findByProps("updateUserStatus");
const IdleIcon = findByProps("Id", "StatusIdle");
const { button } = findByProps("button", "wrapper");
const UserStatusStore = findByStoreName("UserStatusStore");

// 3. HELPER FUNCTIONS
// These check our status using the new settings system
function isAfk() {
    // Access settings via the `.store` property
    const afkMessage = settings.store.quickAfkMessage;
    const currentStatus = UserStatusStore.getStatus();
    const customStatus = UserStatusStore.getCustomStatus();
    return currentStatus === "idle" && customStatus?.text === afkMessage;
}

function toggleAfkStatus() {
    if (isAfk()) {
        StatusUpdater.updateUserStatus("online", { text: "" }, false);
    } else {
        const afkMessage = settings.store.quickAfkMessage;
        const afkEmoji = settings.store.quickAfkEmoji;

        StatusUpdater.updateUserStatus("idle", {
            text: afkMessage,
            emoji: { name: afkEmoji }
        }, false);
    }
}

// 4. OUR CUSTOM BUTTON COMPONENT
// This is the small React component for the button itself
function AfkButton() {
    // This "hook" auto-updates the button when the store changes
    const isCurrentlyAfk = UserStatusStore.useState(() => isAfk());

    return (
        <Tooltip text={isCurrentlyAfk ? "Set Status Online" : "Set Status AFK"} position="top">
            <button
                type="button"
                className={button}
                style={{ color: isCurrentlyAfk ? "var(--green-360)" : "inherit" }}
                onClick={() => toggleAfkStatus()}
            >
                <IdleIcon width="20" height="20" />
            </button>
        </Tooltip>
    );
}

// 5. THE MAIN PLUGIN DEFINITION
export default {
    name: "QuickAFK",
    description: "Adds a button to quickly set an AFK status and message.",
    authors: ["Reever"],
    
    // Assign the settings we defined above
    settings,

    // onStart is called when the plugin is enabled
    onStart() {
        // Find the "AccountDetails" component (the user panel)
        const AccountDetails = findByDisplayName("AccountDetails", { default: true });
        
        // Patch its render function to add our button
        patcher.after("QuickAFK-patch", AccountDetails.prototype, "render", (thisObj, args, res) => {
            // This is the list of buttons (mic, deafen, settings)
            const children = res?.props?.children?.props?.children;
            if (children) {
                // Add our custom button to the end of the list
                children.push(<AfkButton />);
            }
            return res;
        });
    },

    // onStop is called when the plugin is disabled
    onStop() {
        // This automatically removes our patch
        patcher.unpatchAll("QuickAFK-patch");
    }
};