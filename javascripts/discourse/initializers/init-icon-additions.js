import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode } from "discourse-common/lib/icon-library";
import CreateMeeting from "../components/modal/create-meeting";

export default {
    name: "init-icon-additions",

    initialize() {
        withPluginApi("0.8", (api) => {
            const modal = api.container.lookup("service:modal");

            // Decorate the header icons section
            api.decorateWidget("header-icons:before", (helper) => {

                // Create the new header icon
                return helper.h("li.header-icon-meeting", [
                    helper.h(
                        "a.icon.btn-flat",
                        {
                            onclick: () => {
                                modal.show(CreateMeeting, {})
                            },
                            attributes: {
                                target: "_blank",
                                title: "Start a meeting"
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