def report_xcode_summary(platform:)
    path = "xcodebuild-#{platform.downcase}.xcresult"

    xcode_summary.ignores_warnings = false
    xcode_summary.inline_mode = true

    xcode_summary.report(path)
end

warn('This pull request is marked as Work in Progress. DO NOT MERGE!') if github.pr_title.include? "[WIP]"

swiftlint.lint_all_files = true
swiftlint.lint_files(fail_on_error: true, inline_mode: true)

report_xcode_summary(platform: "iOS")
report_xcode_summary(platform: "tvOS")
