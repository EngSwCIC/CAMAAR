function onCardClick() {
    document.getElementById('modal').classList.add('open')
}

document.getElementById('popup-button').addEventListener('click', (event) => {
    document.getElementById('modal').classList.remove('open')
})


Array.from(document.getElementsByClassName('card-template')).forEach( (card) => {
    card.addEventListener('click', (event) => onCardClick())

})