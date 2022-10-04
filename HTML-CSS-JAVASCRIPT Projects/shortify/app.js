const form = document.querySelector(".form");
const inputUrl = form.querySelector("#url");

const shortIt = async (url) => {
    let link;
    try {
        const res = await fetch(`https://api.shrtco.de/v2/shorten?url=e${url}`);
        const resData = await res.json();
        link = {
            output: resData.result["full_short_link2"],
            input: url
        }
    } catch (e) {
        console.log(e)
    }
    return link;
}

const copyToClipboard = (url) => {
    navigator.clipboard.writeText(url)
}

const generateCard = (input, output) => {
    const outputSection = document.querySelector(".output");
    const outputCard = document.createElement(`article`);
    outputCard.classList.add(`output__card`)
    outputCard.innerHTML = `<div class="output__input-url">
    <p>${input}</p>
</div>
<div class="output__output-url">
    <p>${output}</p>
    <button class="copy">Copy</button>
</div>`
    outputSection.append(outputCard);
    const copyBtn = document.querySelector(`.copy`);
    copyBtn.addEventListener(`click`, (e) => {
        copyToClipboard(output);
        e.target.innerHTML = `Copied`;
        setTimeout(() => { e.target.innerHTML = `Copy` }, 3000)
    })
}

form.addEventListener("submit", (e) => {
    e.preventDefault();
    if (inputUrl.value.trim() === ``) {
        return;
    }

    shortIt(inputUrl.value).then(res => {
        generateCard(res.input, res.output);
    })

})