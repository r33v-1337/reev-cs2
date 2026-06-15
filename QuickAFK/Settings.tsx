import { Vencord } from "vencord";
import { Forms, React } from "vencord-webpack";
import { useSetting } from "vencord-components/hooks";

const { FormItem, FormTitle, TextInput } = Forms;

export default () => {
  // Hook into Vencord's settings system
  const [afkMessage, setAfkMessage] = useSetting(
    "quickAfkMessage",
    "I am currently AFK, I'll be responding soon!" // Default message
  );
  
  const [afkEmoji, setAfkEmoji] = useSetting(
    "quickAfkEmoji",
    "🌙" // Default emoji (moon)
  );

  return (
    <div>
      <FormItem>
        <FormTitle>AFK Status Message</FormTitle>
        <TextInput
          value={afkMessage}
          onChange={setAfkMessage}
          placeholder="Enter your AFK message"
        />
      </FormItem>
      
      <FormItem style={{ marginTop: "20px" }}>
        <FormTitle>AFK Status Emoji (e.g., 🌙)</FormTitle>
        <TextInput
          value={afkEmoji}
          onChange={setAfkEmoji}
          placeholder="Enter an emoji"
          maxLength={5} // Emojis can be a few chars
        />
      </FormItem>
    </div>
  );
};