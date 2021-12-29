let allTabs = []
let dateInput
let formatInput
let localeSelect
let formatButton

function hide(el) {
    if (el) {
        el.classList.add("hidden")
    }
}

function show(el) {
    if (el) {
        el.classList.remove("hidden")
    }
}

function setDateResult(result) {
    document.querySelector("span.date-result").innerText = result
}

function formatDate() {
    console.log("date input is: ", dateInput.value)
    console.log("format is: ", formatInput.value)
    console.log("locale is: ", localeSelect.value)

    setDateResult("...")
    fetch("/format", {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            date: encodeURIComponent(dateInput.value),
            format: formatInput.value,
            timezoneOffset: (new Date().getTimezoneOffset() / - 60),
            locale: localeSelect.value
        })
    })
    .then ( (r) => r.text() )
    .then( (result) => {
        console.log(result)
        setDateResult(result)
    })
    .catch( (e) => {
        console.error(e)
    })
}

function tabOn(tab) {
    let tabOnClasses = tab.closest("nav").dataset.tabOn
    let tabOffClasses = tab.closest("nav").dataset.tabOff
    tabOffClasses.split(/\s+/).forEach((c) => tab.classList.remove(c))
    tabOnClasses.split(/\s+/).forEach((c) => tab.classList.add(c))
    let target = document.querySelector(tab.dataset.target)
    if (target) {
        show(target)
    } else {
        console.warn("tab target missing: ", tab.dataset.target)
    }
}

function tabOff(tab) {
    let tabOnClasses = tab.closest("nav").dataset.tabOn
    let tabOffClasses = tab.closest("nav").dataset.tabOff
    tabOnClasses.split(/\s+/).forEach((c) => tab.classList.remove(c))
    tabOffClasses.split(/\s+/).forEach((c) => tab.classList.add(c))
    let target = document.querySelector(tab.dataset.target)
    if (target) {
        hide(target)
    } else {
        console.warn("tab target missing: ", tab.dataset.target)
    }
}

function tabClick(event) {
    allTabs.forEach( (tab) => {
        if (tab == this) {
            tabOn(tab)
        } else {
            tabOff(tab)
        }
    });
}

function setupTabs() {
    allTabs = document.querySelectorAll("nav a[data-target]")

    let selectedTab;
    if (window.location.hash) {
        selectedTab = "." + window.location.hash.substring(1)
    } else {
        selectedTab = allTabs[0].dataset.target
    }

    allTabs.forEach((tab) => {
        tab.addEventListener('click', tabClick);
        (tab.dataset.target == selectedTab) ?
            tabOn(tab) : tabOff(tab);
    })
}

function setupForm() {
    dateInput = document.querySelector("input[name='date-input']")
    formatInput = document.querySelector("input[name='format']")
    localeSelect = document.querySelector("select[name='locale']")
    formatButton = document.querySelector("button[name='format-btn']")

    dateInput.addEventListener('change', formatDate)
    formatInput.addEventListener('change', formatDate)
    localeSelect.addEventListener('change', formatDate)
    formatButton.addEventListener('click', formatDate)
}

document.addEventListener('DOMContentLoaded', function() {
    setupForm()
    setupTabs()
})

