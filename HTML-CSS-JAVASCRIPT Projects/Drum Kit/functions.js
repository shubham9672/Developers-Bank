function handleClick(){
    // this.style.color = "white";
    // var tom1 = new Audio('sounds/tom-1.mp3');
    // tom1.play();
}
for(var a = 0;a<document.querySelectorAll(".drum").length;a++){
document.querySelectorAll(".drum")[a].addEventListener("click",handleClick);
}
//if we use parantheses here in method, it will call method on reload/ load instead of onclick


//anonymous functions:  

// document.querySelector("button").addEventListener("click",function (){
//     alert("I got clicked!!");
// });
