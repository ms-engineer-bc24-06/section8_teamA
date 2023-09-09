'use strict'
// 今日の日付を表示
let date = new Date();
let month = date.getMonth() + 1;
let year = date.getFullYear();
let day = date.getDate();

const minute = document.getElementById("minute");
const second = document.getElementById("second");
const startBtn = document.getElementById("start");
const resetBtn = document.getElementById("reset");

let countNumber = 90;
minute.textContent = `${Math.floor(countNumber / 60)}分`;
second.textContent = `${Math.floor(countNumber % 60)}秒`;

startBtn.addEventListener("click",() => {
    function countDown(){
        countNumber--;
        if (countNumber >= 0){
            let minuteCount = Math.floor(countNumber / 60);
            let secondCount = Math.floor(countNumber % 60);
            minute.textContent = `${minuteCount}分`;
            second.textContent = `${secondCount}秒`;
        } else {
            countNumber = 0;
            clearInterval(intervalId);
        }
    }
    setInterval(countDown, 1000);
});

resetBtn.addEventListener("click",() => {
    location.reload();
});

document.getElementById("today").innerHTML = `${year}年${month}月${day}日`;
