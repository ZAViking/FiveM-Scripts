// Listen for the server event
onNet('permissions:check', (hasGodPermission) => {
    // If the player has god permission
    if (hasGodPermission) {
        // Enable the buttons
        document.getElementById("godCommandButton").disabled = false;
        document.getElementById("godCommandButton").style.opacity = 1;  // Make button fully visible

        document.getElementById("adminCommandButton").disabled = false;
        document.getElementById("adminCommandButton").style.opacity = 1;
    } else {
        // Disable the buttons and grey them out
        document.getElementById("godCommandButton").disabled = true;
        document.getElementById("godCommandButton").style.opacity = 0.5;  // Make button appear greyed out

        document.getElementById("adminCommandButton").disabled = false;
        document.getElementById("adminCommandButton").style.opacity = 1;
    }
});


// Example of opening the admin panel and checking permissions
function openAdminPanel() {
    // Trigger the server to check the player's permissions
    emit('checkPermissions');

    // Show the UI (assumes you have a way to show the panel, like an overlay)
    document.getElementById("adminPanel").style.display = "block";
}
