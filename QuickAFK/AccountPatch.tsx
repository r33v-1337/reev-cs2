import { patcher } from "vencord-helpers";
import { React, findByProps } from "vencord-webpack";
import { Tooltip } from "vencord-components";
import QuickAFKPlugin from "./index"; // Import our main plugin logic

// Find the "moon" icon component from Discord's UI
const IdleIcon = findByProps("Id", "StatusIdle");

export const AccountDetailsButton = (
  props: unknown,
  res: React.ReactElement
) => {
  // We need to find the 'children' of the panel to add our button
  const children = res?.props?.children?.props?.children;
  if (!children) return res;

  // Check if our button is already there
  if (children.find((c: any) => c?.props?.id === "quick-afk-button")) return res;

  // Get the real-time "isAfk" state
  const [isAfk, setIsAfk] = React.useState(QuickAFKPlugin.isAfk());

  // Listen for status changes to update the button's look
  React.useEffect(() => {
    const onStatusChange = () => setIsAfk(QuickAFKPlugin.isAfk());
    
    // Add listeners
    QuickAFKPlugin.addChangeListener(onStatusChange);
    // Remove listeners when done
    return () => QuickAFKPlugin.removeChangeListener(onStatusChange);
  }, []);

  // Add our new button to the list
  children.push(
    <Tooltip text={isAfk ? "Set Status Online" : "Set Status AFK"} position="top">
      <div
        id="quick-afk-button"
        // Use Discord's existing button class
        className={findByProps("button").button} 
        // Make it look "selected" if we are AFK
        style={{ color: isAfk ? "var(--green-360)" : "inherit" }}
        onClick={() => {
          QuickAFKPlugin.toggleAfkStatus();
          // Update state immediately for a responsive feel
          setIsAfk(!isAfk); 
        }}
      >
        <IdleIcon width="20" height="20" />
      </div>
    </Tooltip>
  );

  return res;
};