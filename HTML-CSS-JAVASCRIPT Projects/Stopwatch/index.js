const startStopnBtn = document.querySelector('#startStopBtn');
const resetBtn = document.querySelector('#resetBtn');
const timer = document.querySelector('#timer');

let timerStatus = 'stopped';
let timerInterval = null;

let seconds = 0;
let minutes = 0;
let hours = 0;
let displaySec = 0;
let displayMin = 0;
let displayHr = 0;

function stopWatch() {
    seconds++;
    
    if (seconds === 60) {
        seconds = 0;
        minutes++;
    }
    if (minutes === 60) {
        minutes = 0;
        hours++;
    }

    if (seconds<10) displaySec = "0" + seconds.toString();
    else displaySec = seconds;
    if (minutes<10) displayMin = "0" + minutes.toString();
    else displayMin = minutes;
    if (hours<10) displayHr = "0" + hours.toString();
    else displayHr = hours;    

    timer.innerText = displayHr + ":" + displayMin + ":" + displaySec;
}

startStopnBtn.addEventListener('click',() => {
    if (timerStatus === 'stopped') {
        timerStatus = 'started';
        timerInterval = window.setInterval(stopWatch,1000);
        startStopnBtn.innerHTML = `<i class="fa-solid fa-pause" id="pause"></i>`;
    } else {
        timerStatus = 'stopped';
        window.clearInterval(timerInterval);
        startStopnBtn.innerHTML = `<i class="fa-solid fa-play" id="play"></i>`;
    }
});

resetBtn.addEventListener('click', () => {
    if (timerStatus === 'started') {
        timerStatus = 'stopped';
        window.clearInterval(timerInterval);
        startStopnBtn.innerHTML = `<i class="fa-solid fa-play" id="play"></i>`;
    }

    seconds = 0;
    minutes = 0;
    hours = 0;
    
    timer.innerText = `00:00:00`;
});