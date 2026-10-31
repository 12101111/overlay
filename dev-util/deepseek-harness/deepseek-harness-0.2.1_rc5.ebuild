# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DeepSeek Harness: an agent harness by DeepSeek AI (dsh CLI)"
HOMEPAGE="https://github.com/deepseek-ai/deepseek-harness"

# npm publishes 0.2.1-rc.5, which Gentoo spells 0.2.1_rc5.
MY_PV="0.2.1-rc.5"
MY_TAG="dsh-v${MY_PV}"

# node-addon-require-builtin: commit of `release: 0.1.9`
NARB_COMMIT="a58d3599a2e551d7d706d1ff796c9fd4bbaff63c"
NARB_ARCHIVE="dsh-node-addon-require-builtin-${NARB_COMMIT}"

# The addon's gyp expects node-addon-api 8.x, not 7.1.1 from the
# published dsh tree (pulled in by node-pty)
NAA_PV="8.9.0"

# see `files/README.md` to generate new dependency list.
NPMPKGS="
https://registry.npmjs.org/@agentclientprotocol/sdk/-/sdk-1.4.0.tgz
https://registry.npmjs.org/@anthropic-ai/sdk/-/sdk-0.129.0.tgz
https://registry.npmjs.org/@aws-sdk/client-bedrock-runtime/-/client-bedrock-runtime-3.1127.0.tgz
https://registry.npmjs.org/@aws-sdk/core/-/core-3.979.1.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-env/-/credential-provider-env-3.972.80.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-http/-/credential-provider-http-3.972.82.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-ini/-/credential-provider-ini-3.973.25.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-login/-/credential-provider-login-3.972.87.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-node/-/credential-provider-node-3.972.92.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-process/-/credential-provider-process-3.972.80.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-sso/-/credential-provider-sso-3.973.24.tgz
https://registry.npmjs.org/@aws-sdk/credential-provider-web-identity/-/credential-provider-web-identity-3.972.86.tgz
https://registry.npmjs.org/@aws-sdk/eventstream-handler-node/-/eventstream-handler-node-3.972.40.tgz
https://registry.npmjs.org/@aws-sdk/middleware-eventstream/-/middleware-eventstream-3.972.36.tgz
https://registry.npmjs.org/@aws-sdk/middleware-websocket/-/middleware-websocket-3.972.62.tgz
https://registry.npmjs.org/@aws-sdk/nested-clients/-/nested-clients-3.997.54.tgz
https://registry.npmjs.org/@aws-sdk/signature-v4-multi-region/-/signature-v4-multi-region-3.996.51.tgz
https://registry.npmjs.org/@aws-sdk/token-providers/-/token-providers-3.1127.0.tgz
https://registry.npmjs.org/@aws-sdk/token-providers/-/token-providers-3.1161.0.tgz
https://registry.npmjs.org/@aws-sdk/types/-/types-3.975.0.tgz
https://registry.npmjs.org/@aws-sdk/xml-builder/-/xml-builder-3.972.42.tgz
https://registry.npmjs.org/@aws/lambda-invoke-store/-/lambda-invoke-store-0.3.0.tgz
https://registry.npmjs.org/@babel/code-frame/-/code-frame-7.29.7.tgz
https://registry.npmjs.org/@babel/helper-validator-identifier/-/helper-validator-identifier-7.29.7.tgz
https://registry.npmjs.org/@babel/runtime/-/runtime-7.29.10.tgz
https://registry.npmjs.org/@deepseek-ai/cordis-plugin-group/-/cordis-plugin-group-1.0.5.tgz
https://registry.npmjs.org/@deepseek-ai/cordis-plugin-include/-/cordis-plugin-include-1.0.10.tgz
https://registry.npmjs.org/@deepseek-ai/cordis-plugin-loader/-/cordis-plugin-loader-1.0.6.tgz
https://registry.npmjs.org/@deepseek-ai/cordis-plugin-timer/-/cordis-plugin-timer-1.1.7.tgz
https://registry.npmjs.org/@deepseek-ai/cordis/-/cordis-4.0.5.tgz
https://registry.npmjs.org/@deepseek-ai/cosmokit/-/cosmokit-1.8.6.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-acp-app/-/dsh-acp-app-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-acp/-/dsh-acp-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-default-model/-/dsh-agent-default-model-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-instructions/-/dsh-agent-instructions-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-loop-testkit/-/dsh-agent-loop-testkit-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-loop/-/dsh-agent-loop-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-preset-registry/-/dsh-agent-preset-registry-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-preset/-/dsh-agent-preset-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent-tool-presentation/-/dsh-agent-tool-presentation-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-agent/-/dsh-agent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-anonymous-user-id/-/dsh-anonymous-user-id-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-account-controller/-/dsh-api-account-controller-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-gateway/-/dsh-api-gateway-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-job-controller/-/dsh-api-job-controller-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-remote-access/-/dsh-api-remote-access-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-remotes/-/dsh-api-remotes-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-session-controller/-/dsh-api-session-controller-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-settings-controller/-/dsh-api-settings-controller-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-terminal-controller/-/dsh-api-terminal-controller-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-workspace-controller/-/dsh-api-workspace-controller-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-api-workspace-files/-/dsh-api-workspace-files-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-app-boot/-/dsh-app-boot-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-atomic-write/-/dsh-atomic-write-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-attachment-local/-/dsh-attachment-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-attachment/-/dsh-attachment-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-authorization/-/dsh-authorization-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-base/-/dsh-base-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-bash-local/-/dsh-bash-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-bash-sandbox/-/dsh-bash-sandbox-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-brand/-/dsh-brand-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-chunked-list/-/dsh-chunked-list-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-connection/-/dsh-client-connection-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-file-upload/-/dsh-client-file-upload-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-hmr/-/dsh-client-hmr-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-locale/-/dsh-client-locale-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-modules/-/dsh-client-modules-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-product-analytics/-/dsh-client-product-analytics-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-resources/-/dsh-client-resources-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-shortcuts/-/dsh-client-shortcuts-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-agent-preset/-/dsh-client-ui-agent-preset-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-approval/-/dsh-client-ui-approval-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-attachment/-/dsh-client-ui-attachment-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-brand-official/-/dsh-client-ui-brand-official-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-chat/-/dsh-client-ui-chat-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-commands/-/dsh-client-ui-commands-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-conversation/-/dsh-client-ui-conversation-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-cordis/-/dsh-client-ui-cordis-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-deepseek-model-label-1017/-/dsh-client-ui-deepseek-model-label-1017-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-deliverables/-/dsh-client-ui-deliverables-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-directory-picker-browse/-/dsh-client-ui-directory-picker-browse-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-directory-picker-native/-/dsh-client-ui-directory-picker-native-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-entry-customization/-/dsh-client-ui-entry-customization-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-goal/-/dsh-client-ui-goal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-input-trigger/-/dsh-client-ui-input-trigger-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-jobs/-/dsh-client-ui-jobs-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-layout/-/dsh-client-ui-layout-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-message-feedback/-/dsh-client-ui-message-feedback-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-model-selection/-/dsh-client-ui-model-selection-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-open-in-app/-/dsh-client-ui-open-in-app-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-permission-presets/-/dsh-client-ui-permission-presets-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-plan/-/dsh-client-ui-plan-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-plugin-manager/-/dsh-client-ui-plugin-manager-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-plugin-market/-/dsh-client-ui-plugin-market-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-reference/-/dsh-client-ui-reference-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-renderer/-/dsh-client-ui-renderer-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-schedule/-/dsh-client-ui-schedule-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-secret-mask/-/dsh-client-ui-secret-mask-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-session/-/dsh-client-ui-session-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-account/-/dsh-client-ui-settings-account-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-agent-loop/-/dsh-client-ui-settings-agent-loop-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-general/-/dsh-client-ui-settings-general-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-models/-/dsh-client-ui-settings-models-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-plugin-inventory/-/dsh-client-ui-settings-plugin-inventory-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-plugins/-/dsh-client-ui-settings-plugins-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-session-log/-/dsh-client-ui-settings-session-log-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-shell/-/dsh-client-ui-settings-shell-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-subagent/-/dsh-client-ui-settings-subagent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings-web-search/-/dsh-client-ui-settings-web-search-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-settings/-/dsh-client-ui-settings-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-shortcuts/-/dsh-client-ui-shortcuts-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-sidebar-browser/-/dsh-client-ui-sidebar-browser-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-sidebar-documentpreview/-/dsh-client-ui-sidebar-documentpreview-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-sidebar-files/-/dsh-client-ui-sidebar-files-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-sidebar-right/-/dsh-client-ui-sidebar-right-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-sidebar-terminal/-/dsh-client-ui-sidebar-terminal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-sidebar/-/dsh-client-ui-sidebar-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-skill/-/dsh-client-ui-skill-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-subagent/-/dsh-client-ui-subagent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-theme/-/dsh-client-ui-theme-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-tool/-/dsh-client-ui-tool-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-trajectory/-/dsh-client-ui-trajectory-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-user-questions/-/dsh-client-ui-user-questions-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-workflow-run/-/dsh-client-ui-workflow-run-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-client-ui-workspace/-/dsh-client-ui-workspace-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-cmdline/-/dsh-cmdline-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-command-compact/-/dsh-command-compact-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-command-feedback/-/dsh-command-feedback-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-command-goal/-/dsh-command-goal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-commands/-/dsh-commands-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-compaction-basic/-/dsh-compaction-basic-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-compaction-image-offload/-/dsh-compaction-image-offload-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-compaction-tool-result-pruner/-/dsh-compaction-tool-result-pruner-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-compaction/-/dsh-compaction-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-config-editor/-/dsh-config-editor-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-cordis-client-runner/-/dsh-cordis-client-runner-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-cordis-host-runner/-/dsh-cordis-host-runner-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-credentials-local/-/dsh-credentials-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-credentials/-/dsh-credentials-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-deepseek-account-platform/-/dsh-deepseek-account-platform-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-deepseek-account/-/dsh-deepseek-account-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-deepseek-llm-api-extensions/-/dsh-deepseek-llm-api-extensions-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-deque/-/dsh-deque-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-agent-team-profile/-/dsh-experimental-agent-team-profile-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-agent-team/-/dsh-experimental-agent-team-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-api-speech-to-text/-/dsh-experimental-api-speech-to-text-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-auto-review/-/dsh-experimental-auto-review-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-badge-skill-bundle/-/dsh-experimental-badge-skill-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-client-ui-agent-team/-/dsh-experimental-client-ui-agent-team-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-client-ui-cot-translation/-/dsh-experimental-client-ui-cot-translation-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-client-ui-voice-input/-/dsh-experimental-client-ui-voice-input-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-cot-translation-bundle/-/dsh-experimental-cot-translation-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-inspector-profile/-/dsh-experimental-inspector-profile-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-inspector/-/dsh-experimental-inspector-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-plugin-market-bundle/-/dsh-experimental-plugin-market-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-ptc-runtime-python/-/dsh-experimental-ptc-runtime-python-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-ralph-bundle/-/dsh-experimental-ralph-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-session-inspector/-/dsh-experimental-session-inspector-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-session-search/-/dsh-experimental-session-search-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-session-titles-bundle/-/dsh-experimental-session-titles-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-speech-to-text-sensevoice/-/dsh-experimental-speech-to-text-sensevoice-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-speech-to-text/-/dsh-experimental-speech-to-text-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-terminal-bundle/-/dsh-experimental-terminal-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-tool-agent-team/-/dsh-experimental-tool-agent-team-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-tool-worktree/-/dsh-experimental-tool-worktree-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-translator/-/dsh-experimental-translator-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-voice-input-bundle/-/dsh-experimental-voice-input-bundle-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-experimental-worktree/-/dsh-experimental-worktree-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-file-reference-local/-/dsh-file-reference-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-file-reference/-/dsh-file-reference-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-fs-local/-/dsh-fs-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-fs-observation-policy/-/dsh-fs-observation-policy-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-fs-sandbox/-/dsh-fs-sandbox-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-fs/-/dsh-fs-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-goal-round-driver/-/dsh-goal-round-driver-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-goal/-/dsh-goal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-harness-dev-context/-/dsh-harness-dev-context-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-headless/-/dsh-headless-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-hmr/-/dsh-hmr-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-home-paths/-/dsh-home-paths-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-hook-protocol/-/dsh-hook-protocol-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-hooks-claude-code/-/dsh-hooks-claude-code-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-hooks-codex/-/dsh-hooks-codex-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-directory-picker-auto/-/dsh-host-directory-picker-auto-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-directory-picker-browse/-/dsh-host-directory-picker-browse-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-directory-picker-native/-/dsh-host-directory-picker-native-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-directory-picker/-/dsh-host-directory-picker-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-frontend-static/-/dsh-host-frontend-static-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-open-in-app/-/dsh-host-open-in-app-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-plugin-inventory/-/dsh-host-plugin-inventory-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-product-telemetry-otel/-/dsh-host-product-telemetry-otel-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-host-webserver/-/dsh-host-webserver-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-http-proxy/-/dsh-http-proxy-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-jobs-local/-/dsh-jobs-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-jobs/-/dsh-jobs-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-launch-environment/-/dsh-launch-environment-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-lazy-require/-/dsh-lazy-require-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-deepseek-account/-/dsh-llm-deepseek-account-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-deepseek-api-key/-/dsh-llm-deepseek-api-key-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-deepseek/-/dsh-llm-deepseek-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-mock-server/-/dsh-llm-mock-server-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-pi-ai/-/dsh-llm-pi-ai-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-replay/-/dsh-llm-replay-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm-retry/-/dsh-llm-retry-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-llm/-/dsh-llm-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-loader-smoke/-/dsh-loader-smoke-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-mcp-client/-/dsh-mcp-client-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-mcp-resources/-/dsh-mcp-resources-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-message-feedback/-/dsh-message-feedback-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-native-command/-/dsh-native-command-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-office-to-pdf/-/dsh-office-to-pdf-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-otel/-/dsh-otel-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-output-retention/-/dsh-output-retention-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-package-manifest/-/dsh-package-manifest-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-permission-presets/-/dsh-permission-presets-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-persona/-/dsh-persona-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-plan-mode/-/dsh-plan-mode-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-plugin-manager/-/dsh-plugin-manager-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-plugin-market-index/-/dsh-plugin-market-index-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-plugin-market/-/dsh-plugin-market-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-plugin-package-inventory-deepseek/-/dsh-plugin-package-inventory-deepseek-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-ptc-runtime-node/-/dsh-ptc-runtime-node-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-ptc-runtime/-/dsh-ptc-runtime-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-pwsh-local/-/dsh-pwsh-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-pwsh-sandbox/-/dsh-pwsh-sandbox-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-repeat-tool-reminder/-/dsh-repeat-tool-reminder-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sandbox-local/-/dsh-sandbox-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sandbox-policy/-/dsh-sandbox-policy-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sandbox-windows-acl/-/dsh-sandbox-windows-acl-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sandbox/-/dsh-sandbox-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-schedule/-/dsh-schedule-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-scope/-/dsh-scope-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sdk-app/-/dsh-sdk-app-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sdk-client/-/dsh-sdk-client-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sdk-jsonrpc-server/-/dsh-sdk-jsonrpc-server-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sdk-minimal/-/dsh-sdk-minimal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-sdk-protocol/-/dsh-sdk-protocol-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-checkpoint-policy/-/dsh-session-checkpoint-policy-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-format-catalog/-/dsh-session-format-catalog-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-format-v0-to-v1/-/dsh-session-format-v0-to-v1-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-format-v1-to-v2/-/dsh-session-format-v1-to-v2-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-format-v2-to-v3/-/dsh-session-format-v2-to-v3-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-format-v3-to-v4/-/dsh-session-format-v3-to-v4-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-format/-/dsh-session-format-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-log-deepseek/-/dsh-session-log-deepseek-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-log-export/-/dsh-session-log-export-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-persistence-jsonl/-/dsh-session-persistence-jsonl-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-persistence/-/dsh-session-persistence-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-projection-cache/-/dsh-session-projection-cache-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-projection/-/dsh-session-projection-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-query-sqlite/-/dsh-session-query-sqlite-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-query/-/dsh-session-query-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-reference/-/dsh-session-reference-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-stats/-/dsh-session-stats-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-telemetry-otel/-/dsh-session-telemetry-otel-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-telemetry/-/dsh-session-telemetry-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-title-all-prompts-llm/-/dsh-session-title-all-prompts-llm-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-title-first-prompt-llm/-/dsh-session-title-first-prompt-llm-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-title-llm/-/dsh-session-title-llm-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-title/-/dsh-session-title-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session-turn-outline/-/dsh-session-turn-outline-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-session/-/dsh-session-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-settings/-/dsh-settings-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-shell-env/-/dsh-shell-env-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-shell/-/dsh-shell-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-skill-badge/-/dsh-skill-badge-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-skill-filesystem/-/dsh-skill-filesystem-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-skill-office/-/dsh-skill-office-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-skill/-/dsh-skill-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-spill-local/-/dsh-spill-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-spill-policy/-/dsh-spill-policy-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-spill/-/dsh-spill-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-storage-domain/-/dsh-storage-domain-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-storage-json/-/dsh-storage-json-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-storage/-/dsh-storage-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-subagent-fork-in-process/-/dsh-subagent-fork-in-process-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-subagent-spawn-in-process/-/dsh-subagent-spawn-in-process-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-subagent/-/dsh-subagent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-subprocess-local/-/dsh-subprocess-local-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-subprocess/-/dsh-subprocess-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-system-prompt/-/dsh-system-prompt-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-terminal-bash/-/dsh-terminal-bash-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-terminal/-/dsh-terminal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-time-context/-/dsh-time-context-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-timeout/-/dsh-timeout-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tmux-context/-/dsh-tmux-context-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-token-meter/-/dsh-token-meter-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-ask-user/-/dsh-tool-ask-user-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-bash-persistent/-/dsh-tool-bash-persistent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-bash/-/dsh-tool-bash-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-call-timeout-policy/-/dsh-tool-call-timeout-policy-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-cordis/-/dsh-tool-cordis-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-fs-search/-/dsh-tool-fs-search-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-fs/-/dsh-tool-fs-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-goal/-/dsh-tool-goal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-jobs/-/dsh-tool-jobs-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-present/-/dsh-tool-present-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-pwsh-persistent/-/dsh-tool-pwsh-persistent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-pwsh/-/dsh-tool-pwsh-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-ralph/-/dsh-tool-ralph-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-schedule/-/dsh-tool-schedule-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-session-query/-/dsh-tool-session-query-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-skill/-/dsh-tool-skill-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-str-replace-editor/-/dsh-tool-str-replace-editor-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-subagent-control/-/dsh-tool-subagent-control-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-subagent/-/dsh-tool-subagent-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-terminal/-/dsh-tool-terminal-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-todo/-/dsh-tool-todo-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-web/-/dsh-tool-web-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-workflow/-/dsh-tool-workflow-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-working-directory/-/dsh-tool-working-directory-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tool-workspace-dependencies/-/dsh-tool-workspace-dependencies-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-tools/-/dsh-tools-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-typert-loader/-/dsh-typert-loader-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-typert-protocol/-/dsh-typert-protocol-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-typert-registry/-/dsh-typert-registry-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-user-approval/-/dsh-user-approval-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-user-questions/-/dsh-user-questions-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-util-code-language/-/dsh-util-code-language-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-util-crypto/-/dsh-util-crypto-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-util-time/-/dsh-util-time-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-util-values/-/dsh-util-values-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-util-workspace-path/-/dsh-util-workspace-path-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-web-app/-/dsh-web-app-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-web-deepseek-api/-/dsh-web-deepseek-api-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-web-fetch-http/-/dsh-web-fetch-http-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-web-frontend/-/dsh-web-frontend-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-web-search-deepseek/-/dsh-web-search-deepseek-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-web/-/dsh-web-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-webhook-github/-/dsh-webhook-github-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-webhook/-/dsh-webhook-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-win32-process/-/dsh-win32-process-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-workflow-ptc/-/dsh-workflow-ptc-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-workflow/-/dsh-workflow-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-working-directory/-/dsh-working-directory-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-workspace-changes/-/dsh-workspace-changes-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh-workspace/-/dsh-workspace-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-0.2.1-rc.5.tgz
https://registry.npmjs.org/@deepseek-ai/libreoffice-kit-wasm/-/libreoffice-kit-wasm-0.1.5.tgz
https://registry.npmjs.org/@deepseek-ai/libreoffice-kit/-/libreoffice-kit-0.1.5.tgz
https://registry.npmjs.org/@deepseek-ai/node-addon-system-linux-x64/-/node-addon-system-linux-x64-0.1.2.tgz
https://registry.npmjs.org/@deepseek-ai/node-addon-system/-/node-addon-system-0.1.2.tgz
https://registry.npmjs.org/@deepseek-ai/schemastery/-/schemastery-3.18.5.tgz
https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-1.4.0.tgz
https://registry.npmjs.org/@earendil-works/pi-telemetry/-/pi-telemetry-1.4.0.tgz
https://registry.npmjs.org/@emnapi/runtime/-/runtime-1.11.3.tgz
https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.28.2.tgz
https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.12.2.tgz
https://registry.npmjs.org/@google/genai/-/genai-2.21.0.tgz
https://registry.npmjs.org/@img/colour/-/colour-1.1.0.tgz
https://registry.npmjs.org/@img/sharp-libvips-linux-x64/-/sharp-libvips-linux-x64-1.3.4.tgz
https://registry.npmjs.org/@img/sharp-libvips-linuxmusl-x64/-/sharp-libvips-linuxmusl-x64-1.3.4.tgz
https://registry.npmjs.org/@img/sharp-linux-x64/-/sharp-linux-x64-0.35.5.tgz
https://registry.npmjs.org/@img/sharp-linuxmusl-x64/-/sharp-linuxmusl-x64-0.35.5.tgz
https://registry.npmjs.org/@img/sharp-wasm32/-/sharp-wasm32-0.35.5.tgz
https://registry.npmjs.org/@joplin/turndown-plugin-gfm/-/turndown-plugin-gfm-1.0.68.tgz
https://registry.npmjs.org/@js-temporal/polyfill/-/polyfill-0.5.1.tgz
https://registry.npmjs.org/@keyv/serialize/-/serialize-1.1.1.tgz
https://registry.npmjs.org/@koromix/koffi-linux-x64/-/koffi-linux-x64-3.1.1.tgz
https://registry.npmjs.org/@mixmark-io/domino/-/domino-2.2.0.tgz
https://registry.npmjs.org/@modelcontextprotocol/client/-/client-2.2.0.tgz
https://registry.npmjs.org/@modelcontextprotocol/core/-/core-2.2.0.tgz
https://registry.npmjs.org/@octokit/openapi-types/-/openapi-types-29.0.1.tgz
https://registry.npmjs.org/@octokit/openapi-webhooks-types/-/openapi-webhooks-types-12.1.0.tgz
https://registry.npmjs.org/@octokit/request-error/-/request-error-7.1.2.tgz
https://registry.npmjs.org/@octokit/types/-/types-18.0.0.tgz
https://registry.npmjs.org/@octokit/webhooks-methods/-/webhooks-methods-6.0.0.tgz
https://registry.npmjs.org/@octokit/webhooks/-/webhooks-14.2.0.tgz
https://registry.npmjs.org/@opentelemetry/api-logs/-/api-logs-0.222.0.tgz
https://registry.npmjs.org/@opentelemetry/api/-/api-1.10.0.tgz
https://registry.npmjs.org/@opentelemetry/api/-/api-1.9.1.tgz
https://registry.npmjs.org/@opentelemetry/core/-/core-2.11.0.tgz
https://registry.npmjs.org/@opentelemetry/otlp-exporter-base/-/otlp-exporter-base-0.222.0.tgz
https://registry.npmjs.org/@opentelemetry/otlp-transformer/-/otlp-transformer-0.222.0.tgz
https://registry.npmjs.org/@opentelemetry/resources/-/resources-2.11.0.tgz
https://registry.npmjs.org/@opentelemetry/sdk-logs/-/sdk-logs-0.222.0.tgz
https://registry.npmjs.org/@opentelemetry/sdk-metrics/-/sdk-metrics-2.11.0.tgz
https://registry.npmjs.org/@opentelemetry/sdk-trace/-/sdk-trace-2.11.0.tgz
https://registry.npmjs.org/@opentelemetry/semantic-conventions/-/semantic-conventions-1.44.0.tgz
https://registry.npmjs.org/@protobufjs/aspromise/-/aspromise-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/base64/-/base64-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/codegen/-/codegen-2.0.5.tgz
https://registry.npmjs.org/@protobufjs/eventemitter/-/eventemitter-1.1.1.tgz
https://registry.npmjs.org/@protobufjs/fetch/-/fetch-1.1.1.tgz
https://registry.npmjs.org/@protobufjs/float/-/float-1.0.2.tgz
https://registry.npmjs.org/@protobufjs/path/-/path-1.1.2.tgz
https://registry.npmjs.org/@protobufjs/pool/-/pool-1.1.0.tgz
https://registry.npmjs.org/@protobufjs/utf8/-/utf8-1.1.2.tgz
https://registry.npmjs.org/@sec-ant/readable-stream/-/readable-stream-0.4.1.tgz
https://registry.npmjs.org/@sindresorhus/is/-/is-7.2.0.tgz
https://registry.npmjs.org/@sindresorhus/merge-streams/-/merge-streams-4.0.0.tgz
https://registry.npmjs.org/@smithy/core/-/core-3.38.1.tgz
https://registry.npmjs.org/@smithy/credential-provider-imds/-/credential-provider-imds-4.5.2.tgz
https://registry.npmjs.org/@smithy/fetch-http-handler/-/fetch-http-handler-5.8.0.tgz
https://registry.npmjs.org/@smithy/node-http-handler/-/node-http-handler-4.12.1.tgz
https://registry.npmjs.org/@smithy/node-http-handler/-/node-http-handler-4.14.1.tgz
https://registry.npmjs.org/@smithy/signature-v4/-/signature-v4-5.7.5.tgz
https://registry.npmjs.org/@smithy/types/-/types-4.19.0.tgz
https://registry.npmjs.org/@stablelib/base64/-/base64-1.0.1.tgz
https://registry.npmjs.org/@standard-schema/spec/-/spec-1.1.0.tgz
https://registry.npmjs.org/@swc/helpers/-/helpers-0.5.23.tgz
https://registry.npmjs.org/@types/http-cache-semantics/-/http-cache-semantics-4.2.0.tgz
https://registry.npmjs.org/@types/js-yaml/-/js-yaml-4.0.9.tgz
https://registry.npmjs.org/@types/node/-/node-26.6.6.tgz
https://registry.npmjs.org/@types/retry/-/retry-0.12.0.tgz
https://registry.npmjs.org/@types/ws/-/ws-8.18.1.tgz
https://registry.npmjs.org/@vscode/ripgrep-linux-x64/-/ripgrep-linux-x64-1.18.0.tgz
https://registry.npmjs.org/@vscode/ripgrep/-/ripgrep-1.18.0.tgz
https://registry.npmjs.org/@xterm/addon-serialize/-/addon-serialize-0.14.0.tgz
https://registry.npmjs.org/@xterm/headless/-/headless-6.0.0.tgz
https://registry.npmjs.org/agent-base/-/agent-base-7.1.4.tgz
https://registry.npmjs.org/agent-base/-/agent-base-9.0.0.tgz
https://registry.npmjs.org/ajv/-/ajv-8.20.0.tgz
https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz
https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz
https://registry.npmjs.org/bignumber.js/-/bignumber.js-9.3.1.tgz
https://registry.npmjs.org/bowser/-/bowser-2.15.0.tgz
https://registry.npmjs.org/brotli/-/brotli-1.3.3.tgz
https://registry.npmjs.org/buffer-equal-constant-time/-/buffer-equal-constant-time-1.0.1.tgz
https://registry.npmjs.org/bundle-name/-/bundle-name-4.1.1.tgz
https://registry.npmjs.org/byte-counter/-/byte-counter-0.1.0.tgz
https://registry.npmjs.org/bytes/-/bytes-3.1.2.tgz
https://registry.npmjs.org/cacheable-lookup/-/cacheable-lookup-7.0.0.tgz
https://registry.npmjs.org/cacheable-request/-/cacheable-request-13.0.19.tgz
https://registry.npmjs.org/chokidar/-/chokidar-5.0.0.tgz
https://registry.npmjs.org/clone/-/clone-2.1.2.tgz
https://registry.npmjs.org/commander/-/commander-15.0.0.tgz
https://registry.npmjs.org/compressible/-/compressible-2.0.18.tgz
https://registry.npmjs.org/compression/-/compression-1.8.2.tgz
https://registry.npmjs.org/content-type/-/content-type-2.1.0.tgz
https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz
https://registry.npmjs.org/data-uri-to-buffer/-/data-uri-to-buffer-4.0.1.tgz
https://registry.npmjs.org/debug/-/debug-2.6.9.tgz
https://registry.npmjs.org/debug/-/debug-4.4.3.tgz
https://registry.npmjs.org/decompress-response/-/decompress-response-10.0.0.tgz
https://registry.npmjs.org/default-browser-id/-/default-browser-id-5.0.1.tgz
https://registry.npmjs.org/default-browser/-/default-browser-5.5.1.tgz
https://registry.npmjs.org/define-lazy-prop/-/define-lazy-prop-3.0.0.tgz
https://registry.npmjs.org/depd/-/depd-2.0.0.tgz
https://registry.npmjs.org/destroy/-/destroy-1.2.0.tgz
https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz
https://registry.npmjs.org/dfa/-/dfa-1.2.0.tgz
https://registry.npmjs.org/diff/-/diff-9.0.0.tgz
https://registry.npmjs.org/ecdsa-sig-formatter/-/ecdsa-sig-formatter-1.0.11.tgz
https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz
https://registry.npmjs.org/encodeurl/-/encodeurl-2.0.1.tgz
https://registry.npmjs.org/esbuild/-/esbuild-0.28.2.tgz
https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz
https://registry.npmjs.org/etag/-/etag-1.8.1.tgz
https://registry.npmjs.org/eventsource-parser/-/eventsource-parser-3.1.1.tgz
https://registry.npmjs.org/eventsource/-/eventsource-3.0.7.tgz
https://registry.npmjs.org/execa/-/execa-10.2.1.tgz
https://registry.npmjs.org/extend/-/extend-3.0.2.tgz
https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz
https://registry.npmjs.org/fast-sha256/-/fast-sha256-1.3.0.tgz
https://registry.npmjs.org/fast-uri/-/fast-uri-3.1.9.tgz
https://registry.npmjs.org/fetch-blob/-/fetch-blob-3.2.0.tgz
https://registry.npmjs.org/fflate/-/fflate-0.8.2.tgz
https://registry.npmjs.org/fflate/-/fflate-0.8.3.tgz
https://registry.npmjs.org/figures/-/figures-6.1.0.tgz
https://registry.npmjs.org/fontkit/-/fontkit-2.0.4.tgz
https://registry.npmjs.org/form-data-encoder/-/form-data-encoder-4.1.0.tgz
https://registry.npmjs.org/formdata-polyfill/-/formdata-polyfill-4.0.10.tgz
https://registry.npmjs.org/fresh/-/fresh-2.0.0.tgz
https://registry.npmjs.org/gaxios/-/gaxios-7.3.1.tgz
https://registry.npmjs.org/gcp-metadata/-/gcp-metadata-8.1.2.tgz
https://registry.npmjs.org/get-stream/-/get-stream-9.0.1.tgz
https://registry.npmjs.org/google-auth-library/-/google-auth-library-10.9.1.tgz
https://registry.npmjs.org/google-logging-utils/-/google-logging-utils-1.1.3.tgz
https://registry.npmjs.org/got/-/got-14.6.6.tgz
https://registry.npmjs.org/http-cache-semantics/-/http-cache-semantics-4.3.0.tgz
https://registry.npmjs.org/http-errors/-/http-errors-2.0.1.tgz
https://registry.npmjs.org/http-proxy-agent/-/http-proxy-agent-9.1.0.tgz
https://registry.npmjs.org/http2-wrapper/-/http2-wrapper-2.2.1.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-7.0.6.tgz
https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-9.1.0.tgz
https://registry.npmjs.org/human-signals/-/human-signals-8.0.1.tgz
https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz
https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-2.5.0.tgz
https://registry.npmjs.org/is-docker/-/is-docker-3.0.0.tgz
https://registry.npmjs.org/is-in-ssh/-/is-in-ssh-1.0.0.tgz
https://registry.npmjs.org/is-inside-container/-/is-inside-container-1.0.0.tgz
https://registry.npmjs.org/is-plain-obj/-/is-plain-obj-4.1.0.tgz
https://registry.npmjs.org/is-stream/-/is-stream-4.0.1.tgz
https://registry.npmjs.org/is-unicode-supported/-/is-unicode-supported-2.1.0.tgz
https://registry.npmjs.org/is-wsl/-/is-wsl-3.1.1.tgz
https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz
https://registry.npmjs.org/jose/-/jose-6.2.14.tgz
https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz
https://registry.npmjs.org/js-yaml/-/js-yaml-4.3.2.tgz
https://registry.npmjs.org/jsbi/-/jsbi-4.3.2.tgz
https://registry.npmjs.org/json-bigint/-/json-bigint-1.0.0.tgz
https://registry.npmjs.org/json-schema-to-ts/-/json-schema-to-ts-3.1.1.tgz
https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz
https://registry.npmjs.org/jwa/-/jwa-2.0.1.tgz
https://registry.npmjs.org/jws/-/jws-4.0.1.tgz
https://registry.npmjs.org/keyv/-/keyv-5.6.0.tgz
https://registry.npmjs.org/koffi/-/koffi-3.1.1.tgz
https://registry.npmjs.org/long/-/long-5.3.2.tgz
https://registry.npmjs.org/lowercase-keys/-/lowercase-keys-3.0.0.tgz
https://registry.npmjs.org/mime-db/-/mime-db-1.54.0.tgz
https://registry.npmjs.org/mime-types/-/mime-types-3.0.2.tgz
https://registry.npmjs.org/mimic-response/-/mimic-response-4.0.0.tgz
https://registry.npmjs.org/minisearch/-/minisearch-7.2.0.tgz
https://registry.npmjs.org/ms/-/ms-2.0.0.tgz
https://registry.npmjs.org/ms/-/ms-2.1.3.tgz
https://registry.npmjs.org/negotiator/-/negotiator-0.6.4.tgz
https://registry.npmjs.org/negotiator/-/negotiator-1.1.0.tgz
https://registry.npmjs.org/node-addon-api/-/node-addon-api-7.1.1.tgz
https://registry.npmjs.org/node-addon-native-custom-loader/-/node-addon-native-custom-loader-0.1.9.tgz
https://registry.npmjs.org/node-addon-require-builtin-linux-x64-gnu/-/node-addon-require-builtin-linux-x64-gnu-0.1.9.tgz
https://registry.npmjs.org/node-addon-require-builtin-linux-x64-musl/-/node-addon-require-builtin-linux-x64-musl-0.1.9.tgz
https://registry.npmjs.org/node-addon-require-builtin/-/node-addon-require-builtin-0.1.9.tgz
https://registry.npmjs.org/node-domexception/-/node-domexception-1.0.0.tgz
https://registry.npmjs.org/node-fetch/-/node-fetch-3.3.2.tgz
https://registry.npmjs.org/node-pty/-/node-pty-1.2.0-beta.15.tgz
https://registry.npmjs.org/normalize-url/-/normalize-url-8.1.1.tgz
https://registry.npmjs.org/npm-run-path/-/npm-run-path-6.0.0.tgz
https://registry.npmjs.org/on-finished/-/on-finished-2.4.2.tgz
https://registry.npmjs.org/on-headers/-/on-headers-1.1.0.tgz
https://registry.npmjs.org/open/-/open-11.0.4.tgz
https://registry.npmjs.org/openai/-/openai-7.19.0.tgz
https://registry.npmjs.org/p-cancelable/-/p-cancelable-4.0.1.tgz
https://registry.npmjs.org/p-limit/-/p-limit-7.3.3.tgz
https://registry.npmjs.org/p-retry/-/p-retry-4.6.2.tgz
https://registry.npmjs.org/pako/-/pako-0.2.9.tgz
https://registry.npmjs.org/parse-ms/-/parse-ms-4.0.0.tgz
https://registry.npmjs.org/parseurl/-/parseurl-1.3.3.tgz
https://registry.npmjs.org/partial-json/-/partial-json-0.1.7.tgz
https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz
https://registry.npmjs.org/path-key/-/path-key-4.0.0.tgz
https://registry.npmjs.org/picocolors/-/picocolors-1.1.1.tgz
https://registry.npmjs.org/picomatch/-/picomatch-4.0.7.tgz
https://registry.npmjs.org/pkce-challenge/-/pkce-challenge-5.0.1.tgz
https://registry.npmjs.org/powershell-utils/-/powershell-utils-0.2.1.tgz
https://registry.npmjs.org/pretty-ms/-/pretty-ms-9.3.1.tgz
https://registry.npmjs.org/protobufjs/-/protobufjs-7.6.6.tgz
https://registry.npmjs.org/proxy-agent-negotiate/-/proxy-agent-negotiate-1.1.0.tgz
https://registry.npmjs.org/quick-lru/-/quick-lru-5.1.1.tgz
https://registry.npmjs.org/range-parser/-/range-parser-1.3.0.tgz
https://registry.npmjs.org/readdirp/-/readdirp-5.1.1.tgz
https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz
https://registry.npmjs.org/resolve-alpn/-/resolve-alpn-1.2.1.tgz
https://registry.npmjs.org/resolve.exports/-/resolve.exports-2.0.4.tgz
https://registry.npmjs.org/responselike/-/responselike-4.0.2.tgz
https://registry.npmjs.org/restructure/-/restructure-3.0.2.tgz
https://registry.npmjs.org/retry/-/retry-0.13.1.tgz
https://registry.npmjs.org/run-applescript/-/run-applescript-7.1.0.tgz
https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz
https://registry.npmjs.org/saxes/-/saxes-6.0.0.tgz
https://registry.npmjs.org/semver/-/semver-7.8.5.tgz
https://registry.npmjs.org/send/-/send-1.2.1.tgz
https://registry.npmjs.org/serve-static/-/serve-static-2.2.1.tgz
https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.2.0.tgz
https://registry.npmjs.org/sharp/-/sharp-0.35.5.tgz
https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz
https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz
https://registry.npmjs.org/sherpa-onnx-linux-x64/-/sherpa-onnx-linux-x64-1.13.8.tgz
https://registry.npmjs.org/sherpa-onnx-node/-/sherpa-onnx-node-1.13.8.tgz
https://registry.npmjs.org/signal-exit/-/signal-exit-4.1.0.tgz
https://registry.npmjs.org/standardwebhooks/-/standardwebhooks-1.1.1.tgz
https://registry.npmjs.org/statuses/-/statuses-2.0.2.tgz
https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-4.0.0.tgz
https://registry.npmjs.org/tiny-inflate/-/tiny-inflate-1.0.3.tgz
https://registry.npmjs.org/toidentifier/-/toidentifier-1.0.1.tgz
https://registry.npmjs.org/ts-algebra/-/ts-algebra-2.0.0.tgz
https://registry.npmjs.org/tslib/-/tslib-2.9.1.tgz
https://registry.npmjs.org/tsx/-/tsx-4.23.15.tgz
https://registry.npmjs.org/turndown/-/turndown-7.2.4.tgz
https://registry.npmjs.org/type-fest/-/type-fest-4.41.0.tgz
https://registry.npmjs.org/typebox/-/typebox-1.3.27.tgz
https://registry.npmjs.org/undici-types/-/undici-types-8.9.0.tgz
https://registry.npmjs.org/undici/-/undici-8.11.2.tgz
https://registry.npmjs.org/unicode-properties/-/unicode-properties-1.4.1.tgz
https://registry.npmjs.org/unicode-trie/-/unicode-trie-2.0.0.tgz
https://registry.npmjs.org/unicorn-magic/-/unicorn-magic-0.3.0.tgz
https://registry.npmjs.org/vary/-/vary-1.1.2.tgz
https://registry.npmjs.org/web-streams-polyfill/-/web-streams-polyfill-3.3.3.tgz
https://registry.npmjs.org/which-command/-/which-command-0.1.0.tgz
https://registry.npmjs.org/which/-/which-2.0.2.tgz
https://registry.npmjs.org/ws/-/ws-8.21.3.tgz
https://registry.npmjs.org/wsl-utils/-/wsl-utils-1.0.1.tgz
https://registry.npmjs.org/xmlchars/-/xmlchars-2.2.0.tgz
https://registry.npmjs.org/yaml/-/yaml-2.9.1.tgz
https://registry.npmjs.org/yocto-queue/-/yocto-queue-1.2.2.tgz
https://registry.npmjs.org/yoctocolors/-/yoctocolors-2.2.0.tgz
https://registry.npmjs.org/zod/-/zod-4.4.3.tgz
https://registry.npmjs.org/zod/-/zod-4.6.7.tgz
"

npm_distfile() {
	local url=${1#https://registry.npmjs.org/}
	local pkg=${url%%/-/*}
	local file=${url##*/}

	if [[ ${pkg} == @* ]]; then
		echo "${pkg//\//-}-${file#"${pkg##*/}-"}"
	else
		echo "${file}"
	fi
}

npm_uris() {
	local url dist

	for url in "$@"; do
		dist=$(npm_distfile "${url}")
		if [[ ${dist} == "${url##*/}" ]]; then
			echo "${url}"
		else
			echo "${url} -> ${dist}"
		fi
	done
}

SRC_URI="
	https://registry.npmjs.org/@deepseek-ai/dsh/-/dsh-${MY_PV}.tgz -> ${P}.tgz
	https://github.com/deepseek-ai/deepseek-harness/archive/refs/tags/${MY_TAG}.tar.gz -> ${P}-upstream.tar.gz
	https://github.com/deepseek-ai/dsh-node-addon-require-builtin/archive/${NARB_COMMIT}.tar.gz -> ${NARB_ARCHIVE}.tar.gz
	https://registry.npmjs.org/node-addon-api/-/node-addon-api-${NAA_PV}.tgz
	$(npm_uris ${NPMPKGS})
"
S="${WORKDIR}/package"

# MIT: deepseek harness and node-addon-require-builtin;
# BSD: the native/system C sources (Landlock launcher, flock addon).
LICENSE="MIT BSD"

SLOT="0"
# https://github.com/deepseek-ai/dsh-node-addon-require-builtin/tree/master/packages/native/src/runtime_context
# only arm64 and x64 are supported
KEYWORDS="~amd64 ~arm64"

IUSE="+sharp"

DEPEND="
	>=sys-apps/pnpm-12
	>=net-libs/nodejs-22.19
	sharp? ( media-libs/vips )
"
RDEPEND="
	sys-apps/ripgrep
"
RESTRICT="mirror"

node_arch() {
	case "${ARCH}:${ABI}" in
	  *:amd64) echo "x64" ;;
	  *:arm) echo "arm" ;;
	  *:arm64) echo "arm64" ;;
	  loong:lp64*) echo "loong64" ;;
	  riscv:lp64*) echo "riscv64" ;;
	  *) die "${ARCH} ${ABI} not supported";;
	esac
}

node_libc() {
	if use elibc_musl; then
		echo "musl"
	else
		echo "gnu"
	fi
}

node_libcdir() {
	if use elibc_musl; then
		echo "musl"
	else
		echo "glibc"
	fi
}

# resolve path to node-gyp from npm.
node_gyp() {
	local npm_cli

	npm_cli=$(readlink -f "$(command -v npm)") || die "npm not found"
	printf '%s\n' "$(dirname "${npm_cli}")/../node_modules/node-gyp/bin/node-gyp.js"
}

# node-pty ships sources and prebuilt binary. lib/utils.js probes build/Release before prebuilds/.
build_node_pty() {
	local pty="${S}/node_modules/node-pty"
	local patch="${WORKDIR}/deepseek-harness-${MY_TAG}/patches/node-pty@1.2.0-beta.15.patch"

	cd "${pty}" || die
	rm -rf build prebuilds || die

	patch -p1 < "${patch}" || die "failed to apply the node-pty patch"

	node "$(node_gyp)" rebuild --nodedir="${EPREFIX}/usr" \
		|| die "node-pty build failed"
	[[ -f build/Release/pty.node ]] || die "node-pty addon missing"

	find build -mindepth 1 -maxdepth 1 ! -name Release -exec rm -rf {} + || die
	rm -rf build/Release/obj.target build/Release/.deps \
		build/Release/node-addon-api node-addon-api || die
}

# sharp ships sources and prebuilt binary. src/build/Release is used before the @img/* packages.
build_sharp() {
	local sharp="${S}/node_modules/sharp"
	local plat="linux-$(node_arch)"
	local ver

	use elibc_musl && plat="linuxmusl-$(node_arch)"

	cd "${sharp}" || die
	ver=$(node -p 'require("./package.json").version') || die

	# force to link against a global libvips
	SHARP_FORCE_GLOBAL_LIBVIPS=1 \
		node "$(node_gyp)" rebuild --directory=src --nodedir="${EPREFIX}/usr" \
		|| die "sharp build failed"
	[[ -f "src/build/Release/sharp-${plat}-${ver}.node" ]] \
		|| die "sharp addon missing for ${plat}"

	find src/build -mindepth 1 -maxdepth 1 ! -name Release -exec rm -rf {} + || die
	rm -rf src/build/Release/obj.target src/build/Release/.deps \
		src/build/Release/node-addon-api src/build/Release/nothing.a || die

	rm -rf "${S}"/node_modules/@img/sharp* || die
}

# build @deepseek-ai/node-addon-system-${platform}-${arch}.
build_node_addon_system() {
	local src="${WORKDIR}/deepseek-harness-${MY_TAG}/native/system/packages/entry/src"
	local dest="${S}/node_modules/@deepseek-ai/node-addon-system-linux-$(node_arch)"

	rm -rf "${S}"/node_modules/@deepseek-ai/node-addon-system-linux-* || die
	mkdir -p "${dest}/bin/$(node_libcdir)" || die
	cd "${src}" || die

	# flangs mirror native/system/scripts/build.ts.
	$(tc-getCC) -shared -fPIC -O2 -std=c11 -Wall -Wextra -fvisibility=hidden \
		-DNAPI_VERSION=8 -I "${EPREFIX}/usr/include/node" \
		-o "${dest}/bin/$(node_libcdir)/system.node" flock.c \
		|| die "flock addon build failed"

	if ! $(tc-getCC) -std=c11 -Os -static -o "${dest}/bin/landlock-run" main.c; then
		ewarn "no static libc available; the Landlock launcher is now dynamic"
		$(tc-getCC) -std=c11 -Os -o "${dest}/bin/landlock-run" main.c \
			|| die "landlock-run build failed"
	fi

	# remove prebuilds.json
	cat > "${dest}/package.json" <<-EOF || die
	{
	  "name": "@deepseek-ai/node-addon-system-linux-$(node_arch)",
	  "version": "0.1.2",
	  "description": "Linux $(node_arch) system binaries: static Landlock launcher and glibc/musl Node-API flock addons",
	  "os": ["linux"],
	  "cpu": ["$(node_arch)"],
	  "files": ["bin/"],
	  "engines": { "node": ">=20" },
	  "license": "BSD-3-Clause"
	}
	EOF
}

# node-addon-require-builtin currently support x64/arm64
build_node_addon_require_builtin() {
	local narb="${WORKDIR}/${NARB_ARCHIVE}"
	local dest

	rm -rf "${S}"/node_modules/node-addon-require-builtin-linux-* || die

	case $(node_arch) in
	x64|arm64) ;;
	*)
		ewarn "node-addon-require-builtin has no $(node_arch) runtime sources"
		ewarn "the internal-loader/HMR fallback remains unavailable on ${ARCH}"
		return
		;;
	esac

	cd "${narb}/packages/native" || die
	rm -rf build node_modules || die
	mkdir -p node_modules || die
	ln -s "${WORKDIR}/node-addon-api-${NAA_PV}" node_modules/node-addon-api || die

	# The gyp file defaults to the sibling "internal-loader" product, so the
	# product and backend have to be selected explicitly.
	GYP_DEFINES="narb_backend=napi narb_product=require-builtin" \
		node "$(node_gyp)" rebuild --nodedir="${EPREFIX}/usr" \
		|| die "node-addon-require-builtin build failed"

	# Layout probed by node-addon-native-custom-loader after the deleted optional platform package:
	# build/<backend>/<abi>-<platform>/require_builtin.node
	dest="${S}/node_modules/node-addon-require-builtin/build/napi"
	dest+="/napi-v9-linux-$(node_arch)-$(node_libc)"
	mkdir -p "${dest}" || die
	cp build/Release/require_builtin.node "${dest}/" || die
}

provide_ripgrep() {
	local dest="${S}/node_modules/@vscode/ripgrep-linux-$(node_arch)"

	rm -rf "${S}"/node_modules/@vscode/ripgrep-linux-* || die
	mkdir -p "${dest}/bin" || die

	# remove prebuilds.json
	cat > "${dest}/package.json" <<-EOF || die
	{
	  "name": "@vscode/ripgrep-linux-$(node_arch)",
	  "version": "1.18.0",
	  "description": "ripgrep binary for linux-$(node_arch). Used by @vscode/ripgrep.",
	  "os": ["linux"],
	  "cpu": ["$(node_arch)"],
	  "files": ["bin/"],
	  "license": "MIT"
	}
	EOF
}

# Koffi is used for loading Win32 API calls
# sherpa is an optional and disable by default Speech-to-text/Text-to-speech engine
# to package and use sherpa:
# 1. install sci-libs/onnxruntime or bin
# 2. install sci-ml/sherpa-onnx::stuff or bin
# 3. build node addon
drop_prebuilt_payloads() {
	rm -rf "${S}/node_modules/koffi" "${S}/node_modules/@koromix" || die
	rm -rf "${S}/node_modules/sherpa-onnx-node" \
		"${S}"/node_modules/sherpa-onnx-linux-* || die
	use sharp || rm -rf "${S}"/node_modules/@img/sharp* || die
}

src_unpack() {
	# the js/html part of dsh
	unpack "${P}.tgz"
	# the native source code part of dsh
	unpack "${P}-upstream.tar.gz"
	# node-addon-require-builtin
	unpack "${NARB_ARCHIVE}.tar.gz"

	# node-addon-api 8.x
	mkdir -p "${WORKDIR}/node-addon-api-${NAA_PV}" || die
	tar -xzf "${DISTDIR}/node-addon-api-${NAA_PV}.tgz" \
		-C "${WORKDIR}/node-addon-api-${NAA_PV}" --strip-components=1 || die
}

src_compile() {
	local registry="${WORKDIR}/npm-registry"
	local url rel dist

	export HOME="${T}/home"
	export XDG_RUNTIME_DIR="${HOME}/run"
	export XDG_CACHE_HOME="${HOME}/cache"
	export XDG_DATA_HOME="${HOME}/data"
	export XDG_STATE_HOME="${HOME}/state"
	mkdir -p "${HOME}" "${XDG_RUNTIME_DIR}" "${XDG_CACHE_HOME}" \
		"${XDG_DATA_HOME}" "${XDG_STATE_HOME}" || die

	cd "${S}" || die

	mkdir -p "${registry}" || die
	for url in ${NPMPKGS}; do
		rel="${url#https://registry.npmjs.org/}"
		dist=$(npm_distfile "${url}")
		mkdir -p "${registry}/${rel%/*}" || die
		ln -s "${DISTDIR}/${dist}" "${registry}/${rel}" || die
	done

	cp "${FILESDIR}/pnpm-lock.yaml" "${S}/pnpm-lock.yaml" || die

	# minimumReleaseAge: need a real registry
	# ignore-scripts: every native object is built explicitly below
	pnpm install \
		--prod \
		--frozen-lockfile \
		--ignore-scripts \
		--store-dir="${T}/pnpm-store" \
		--config.registry="file://${registry}" \
		--config.node-linker=hoisted \
		--config.minimumReleaseAge=0 \
		--config.update-notifier=false \
		--config.manage-package-manager-versions=false || die

	build_node_pty
	use sharp && build_sharp
	build_node_addon_system
	build_node_addon_require_builtin
	provide_ripgrep
	drop_prebuilt_payloads

	# cleanup build-only pnpm metadata.
	rm -rf "${S}/node_modules/.pnpm" \
		"${S}/node_modules/.modules.yaml" \
		"${S}/node_modules/.pnpm-workspace-state-v1.json" \
		"${S}/node_modules/.bin" \
		"${S}/pnpm-lock.yaml" || die
}

src_install() {
	local install_dir="/usr/$(get_libdir)/node_modules/@deepseek-ai/dsh"
	local exe

	insinto "${install_dir}"
	doins -r "${S}"/* || die

	# doins installs files as 0644; restore the modes build produced for the
	# native helpers (landlock-run, pty.node, ...).
	while IFS= read -r -d '' exe; do
		fperms +x "${install_dir}/${exe#"${S}"/}"
	done < <(find "${S}" -type f -perm /111 -print0)

	dosym -r "${EPREFIX}/usr/bin/rg" \
		"${install_dir}/node_modules/@vscode/ripgrep-linux-$(node_arch)/bin/rg"

	fperms +x "${install_dir}/lib/bin.js"
	dosym -r "${install_dir}/lib/bin.js" /usr/bin/dsh
}

pkg_postinst() {
	elog "Run 'dsh web' (browser UI) or 'dsh --profile headless \"task\"' (one-shot); see 'dsh --help' for all profiles."
}
