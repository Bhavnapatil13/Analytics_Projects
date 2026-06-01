// 1. Set the secret code!
const SECRET_CODE = "1113"; // Change this to whatever you want!
let currentInput = "";

// --- PASSCODE LOGIC ---

function addNumber(num) {
    if (currentInput.length < 4) {
        currentInput += num;
        updateDisplay();
    }
}

function clearPasscode() {
    currentInput = "";
    updateDisplay();
    document.getElementById("error-msg").innerText = ""; 
}

function updateDisplay() {
    let displayStr = currentInput.padEnd(4, "_").split("").join(" ");
    document.getElementById("display").innerText = displayStr;
}

function checkPasscode() {
    if (currentInput === SECRET_CODE) { 
        // Hide the passcode screen
        document.getElementById("passcode-screen").style.display = "none";
        
        // Show the NEW Congratulation screen!
        document.getElementById("congratulation-screen").style.display = "block";
    } else {
        document.getElementById("error-msg").innerText = "Wrong passcode, try again!";
        currentInput = "";
        setTimeout(updateDisplay, 500); 
    }
}

// --- NAVIGATION LOGIC ---

// This function hides ALL screens, then shows only the one you asked for
function goToScreen(screenId) {
    // Get all elements that have the class 'screen'
    let allScreens = document.querySelectorAll('.screen');
    
    
    
    // Loop through them and remove the 'active' class to hide them
    allScreens.forEach(screen => {
        screen.classList.remove('active');
    });

    // Find the specific screen we want and add the 'active' class to show it
    document.getElementById(screenId).classList.add('active');
}
// Function to move from Congratulation to the Gift Box prompt
function goToPromptScreen() {
    document.getElementById("congratulation-screen").style.display = "none";
    document.getElementById("prompt-screen").style.display = "block";
}
// 1. If they click NO, show the "Pretty Please" screen
function clickNo() {
    document.getElementById("prompt-screen").style.display = "none";
    document.getElementById("no-screen").style.display = "block";
}

// 2. If they click TRY AGAIN, take them back to the gift box
function clickTryAgain() {
    document.getElementById("no-screen").style.display = "none";
    document.getElementById("prompt-screen").style.display = "block";
}

// 3. If they click YES, show the Cake!
function clickYes() {
    document.getElementById("prompt-screen").style.display = "none";
    document.getElementById("cake-screen").style.display = "block";
}

// 4. If they click BLOW, show the final baby picture screen
function clickBlow() {
    document.getElementById("cake-screen").style.display = "none";
    document.getElementById("after-blow-screen").style.display = "block";
}
// Function to go from the baby picture to the Menu
function goToMenu() {
    document.getElementById("after-blow-screen").style.display = "none";
    document.getElementById("menu-screen").style.display = "block";
}

// Placeholder functions for the final 3 surprise pages!
function openMemories() {
    alert("We will build the Memories page next!");
}

function openLetter() {
    alert("We will build the Letter page next!");
}

function openGift() {
    alert("We will build the Secret Gift page next!");
}
