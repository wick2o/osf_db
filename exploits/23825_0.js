tell application "Safari"
        do JavaScript "alert(document.loginform.password.value)" in document 1
end tell
