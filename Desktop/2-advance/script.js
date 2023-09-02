
let circles = document.querySelectorAll(".circle");
let startBtn = document.getElementById("startBtn");
let stopBtn = document.getElementById("stopBtn");
let timer;
let currentCircleIndex = 0;

function changeColor() {
    circles[currentCircleIndex].classList.remove("blue", "yellow", "red");
    let nextColor = "";
    switch (currentCircleIndex) {
        case 0:
            nextColor = "blue";
            break;
        case 1:
            nextColor = "yellow";
            break;
        case 2:
            nextColor = "red";
            break;
        default:
            break;
    }
    circles[currentCircleIndex].classList.add(nextColor);
    currentCircleIndex = (currentCircleIndex + 1) % circles.length;
}

startBtn.addEventListener("click", () => {
    changeColor();
    timer = setInterval(changeColor, 2000);
    startBtn.disabled = true;
    stopBtn.disabled = false;
});

stopBtn.addEventListener("click", () => {
    clearInterval(timer);
    circles[currentCircleIndex].classList.remove("blue", "yellow", "red");
    circles[currentCircleIndex].classList.add("white");
    currentCircleIndex = 0;
    startBtn.disabled = false;
    stopBtn.disabled = true;
});

stopBtn.disabled = true;
