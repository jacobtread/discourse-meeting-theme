/*eslint no-undef:0 */

import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import TextField from "discourse/components/text-field";
import i18n from "discourse-common/helpers/i18n";

export default class CreateMeeting extends Component {
  // User specified room ID
  @tracked jitsiRoom = "";

  // Randomly generated meeting ID
  randomMeetingID = Math.random().toString(36).slice(-8);

  get meetingURL() {
    let meetingID = "";

    // Use the random meeting URL unless a room is specified
    if (this.jitsiRoom.length > 0) {
      meetingID = this.purifyMeetingID(this.jitsiRoom);
    }

    // If a custom meeting is empty or not specified use a random one
    if (meetingID.length === 0) {
      meetingID = this.randomMeetingID;
    }

    const domain = settings.meet_jitsi_domain;
    const meetingURL = new URL(meetingID, `https://${domain}`);

    return meetingURL.toString();
  }

  purifyMeetingID(meetingID) {
    let purifiedMeetingID = meetingID.trim();

    // Strip non-alphanumeric characters for better URL safety and encoding
    purifiedMeetingID = purifiedMeetingID.replace(/[^a-zA-Z0-9 ]/g, "");

    // Collapse spaces into camel case for better URL encoding
    purifiedMeetingID = purifiedMeetingID.replace(/\w+/g, function(txt) {
        // uppercase first letter and add rest unchanged
        return txt.charAt(0).toUpperCase() + txt.substring(1);
    })
    // remove any spaces
    .replace(/\s/g, '');
    return purifiedMeetingID;
  }


  keyDown(e) {
    if (e.keyCode === 13) {
      e.preventDefault();
      e.stopPropagation();
      return false;
    }
  }

  // Action for opening the meeting in a new window
  @action
  openMeeting() {
    this.args.closeModal();
    window.open(this.meetingURL, "_blank");
  }

  @action
  copyMeetingURL() {
      const text = this.meetingURL;
      if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
        const textarea = document.createElement("textarea");
        textarea.textContent = text;
         // Prevent scrolling to bottom of page in Microsoft Edge
        textarea.style.position = "fixed";
        document.body.appendChild(textarea);
        textarea.select();

        try {
          document.execCommand("copy");
          return;
        } catch (ex) {
          // Security exception may be thrown by some browsers
        } finally {
          document.body.removeChild(textarea);
        }
      }

      // Fallback to prompt for manual copying
      // eslint-disable-next-line no-alert
      prompt("Copy to clipboard: Ctrl+C, Enter", text);
  }

  @action
  cancel() {
    this.args.closeModal();
  }

  <template>
    <DModal
      @title={{i18n (themePrefix "modal.title")}}
      class="create-meeting"
      @closeModal={{@closeModal}}
    >
      <:body>
        <div class="create-meeting-form">
          <div class="create-meeting-input">
            <label>
              {{i18n (themePrefix "room_label")}}
            </label>
            <TextField
              @value={{this.jitsiRoom}}
              @autofocus="autofocus"
              @autocomplete="off"
            />
            <div class="desc">
                {{i18n (themePrefix "modal.room_field_description")}}
            </div>
          </div>
          <p class="desc">
            {{i18n (themePrefix "modal.url_description")}}
          </p>
          <label>
            {{i18n (themePrefix "room_url_label")}}
          </label>
          <div class="inline-form full-width">
            <TextField
              @value={{this.meetingURL}}
              @ontype
              readonly
              minlength="6"
            />
            <DButton
                class="btn-primary btn-icon btn-copy"
                @disabled={{this.insertDisabled}}
                @title={{themePrefix "modal.copy"}}
                @action={{this.copyMeetingURL}}
                @icon="copy"
            />
          </div>
        </div>
      </:body>
      <:footer>
        <DButton
          class="btn-primary"
          @disabled={{this.insertDisabled}}
          @label={{themePrefix "modal.open"}}
          @action={{this.openMeeting}}
        />
      </:footer>
    </DModal>
  </template>
}