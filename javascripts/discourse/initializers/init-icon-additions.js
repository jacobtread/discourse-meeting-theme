import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode } from "discourse-common/lib/icon-library";

export default {
    name: "video-button-component",

    initialize() {
        withPluginApi("0.8", (api) => {
            const meetingURL = settings.Meeting_url;

            // Decorate the header icons section
            api.decorateWidget("header-icons:before", (helper) => {

                // Create the new header icon
                return helper.h("li.header-icon-meeting", [
                    helper.h(
                        "a.icon.btn-flat",
                        {
                            attributes: {
                                href: meetingURL,
                                target: "_blank"
                            }
                        },
                        // Use the video icon
                        iconNode("video")
                    ),
                ]);
            });

        });
    },
};