############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scrollrolldatepickermodule")
#endregion

############################################################
template = ""

############################################################
inputId = "login-birthday-input"

############################################################
#region DOM Cache
inputElement = null
outerContainer = null
datepickerContainer = null

dayPicker = null
monthPicker = null
yearPicker = null

#endregion

############################################################
inputHeight = 0
width = 0

############################################################
export initialize = ->
    log "initialize"
    ## this could by called as initialize(inputId)
    inputElement = document.getElementById(inputId)

    ## creating the container Elements
    outerContainer = document.createElement("div")
    datepickerContainer = document.createElement("div")

    ## adding the expected classes
    inputElement.classList.add("scroll-roll-input")
    outerContainer.classList.add("scroll-roll-container")
    datepickerContainer.classList.add("scroll-roll-datepicker-container")

    ## arrange the DOM 
    inputElement.replaceWith(outerContainer)
    outerContainer.append(inputElement)
    outerContainer.append(datepickerContainer)

    ## inject the HTML
    template = scrollrolldatepickerHiddenTemplate.innerHTML
    datepickerContainer.innerHTML = template

    ## further setup
    inputHeight = inputElement.getBoundingClientRect().height
    log inputHeight
    datepickerContainer.style.setProperty("--scrollroll-frame-height", "#{inputHeight}px")
    inputElement.addEventListener("click", inputElementClicked)
    
    dayPicker = datepickerContainer.getElementsByClassName("scrollroll-day-picker")[0]
    monthPicker = datepickerContainer.getElementsByClassName("scrollroll-month-picker")[0]
    yearPicker = datepickerContainer.getElementsByClassName("scrollroll-year-picker")[0]

    addDayElements(dayPicker)
    addMonthElements(monthPicker)
    addYearElements(yearPicker)
    return

############################################################
inputElementClicked = (evnt) ->
    log "inputElementClicked"
    evnt.preventDefault()
    openScrollRollDatepicker()
    return false

openScrollRollDatepicker = ->
    log "openScrollRollDatepicker"
    datepickerContainer.classList.add("shown")
    return



############################################################
addDayElements = (picker) ->
    log "addDayElements"
    html = "<div class='scrollroll-element-space'></div>"    
    for day in [1..9]
        html += "<div class='scrollroll-element'>0#{day}</div>"
    for day in [10..31]
        html += "<div class='scrollroll-element'>#{day}</div>"
    html += "<div class='scrollroll-element-space'></div>"
    picker.innerHTML = html
    return

addMonthElements = (picker) ->
    log "addMonthElements" 
    html = "<div class='scrollroll-element-space'></div>"
    for month in [1..9]
        html += "<div class='scrollroll-element'>0#{month}</div>"
    for month in [10..12]
        html += "<div class='scrollroll-element'>#{month}</div>"
    html += "<div class='scrollroll-element-space'></div>"
    picker.innerHTML = html
    return

addYearElements = (picker) ->
    log "addYearElements"
    currentYear = new Date().getFullYear()
    oldestYear = currentYear - 150
    html = "<div class='scrollroll-element-space'></div>"
    for year in[oldestYear..currentYear]
        html += "<div class='scrollroll-element'>#{year}</div>"
    html += "<div class='scrollroll-element-space'></div>"
    picker.innerHTML = html
    return