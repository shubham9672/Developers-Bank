const modal = document.querySelector(".pop-up");
const button = document.querySelector(".celebrate");
const body = document.querySelector(".body");
const closePop = document.querySelector(".close");
const confettiVisible = document.querySelector(".confettiHidden")

var confettiSettings = { target: 'my-canvas' };
var confetti = new ConfettiGenerator(confettiSettings);
confetti.render();

button.addEventListener("click",()=>{
    modal.classList.toggle("pop_up_Visible");
    confettiVisible.classList.toggle("confettiVisible");
})

closePop.addEventListener("click",()=>{
    modal.classList.toggle("pop_up_Visible");
    confettiVisible.classList.toggle("confettiVisible");
})


