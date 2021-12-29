function show(el) {
    if (el) {
        el.classList.remove("hidden")
    }
}

function hide(el) {
    if (el) {
        el.classList.add("hidden");
    }
}

export { show, hide };
