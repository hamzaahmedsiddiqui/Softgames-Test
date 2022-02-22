
function getFullName() {
    var firstName = $("#fname").val();
    var lastName = $("#lname").val();
    
    var Dict = {};
    Dict.firstName= firstName;
    Dict.lastName= lastName;
    window.webkit.messageHandlers.fullNameMessageHandler.postMessage(Dict);
}

function checkAge() {
    var dobirth = $("#dobirth").val();
    var Dict = {};
    Dict.dobirth= dobirth;
    window.webkit.messageHandlers.ageMessageHandler.postMessage(Dict);
}
function fillFullName(jsonData){
    var userData = JSON.parse(jsonData);
    document.getElementById('lblFullName').innerHTML = "Full Name:" + userData["fullName"];
}
function fillAge(jsonData){
    var userData = JSON.parse(jsonData);
    document.getElementById('lblAge').innerHTML = "Age:" + userData["age"];
}
function getNotification(){
    window.webkit.messageHandlers.getNotificationMessageHandler.postMessage({});
}

