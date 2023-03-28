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

acceptButton = null

dayPicker = null
monthPicker = null
yearPicker = null

#endregion

############################################################
#region Day, Month and Year Values
allDayStrings = [
    "01"
    "02"
    "03"
    "04"
    "05"
    "06"
    "07"
    "08"
    "09"
    "10"
    "11"
    "12"
    "13"
    "14"
    "15"
    "16"
    "17"
    "18"
    "19"
    "20"
    "21"
    "22"
    "23"
    "24"
    "25"
    "26"
    "27"
    "28"
    "29"
    "30"
    "31"
]

############################################################
allMonthStrings = [
    "01"
    "02"
    "03"
    "04"
    "05"
    "06"
    "07"
    "08"
    "09"
    "10"
    "11"
    "12"
]

############################################################
currentYear = new Date().getFullYear()
oldestYear = currentYear - 150
allYears = [oldestYear..currentYear]

leapYears = allYears.filter((year) -> return !(year % 4))
log leapYears
daysForMonth = [
    31, # jan
    28, # feb
    31, # mar
    30, # apr
    31, # may
    30, # jun
    31, # jul
    31, # aug
    30, # sep
    31, # oct
    30, # nov
    31 # dec
]

#endregion

############################################################
inputHeight = 0
width = 0

############################################################
visibleElements = 0

############################################################
nexHeartbeat = () -> return

############################################################
export initialize = ->
    log "initialize"
    ## this could by called as initialize(inputId)
    inputElement = document.getElementById(inputId)
    # inputElement.setAttribute("type", "text")
    # inputElement.setAttribute("placeholder", "dd.mm.yyyy")
    
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
    if inputHeight % 2 then inputHeight += 1
    log inputHeight
    datepickerContainer.style.setProperty("--scrollroll-frame-height", "#{inputHeight}px")

    outerHeight = datepickerContainer.getBoundingClientRect().height
    log "outerHeight #{outerHeight}"    
    visibleElements = Math.ceil(outerHeight / (2 * inputHeight))
    log "visibleElements: #{visibleElements}"
    
    acceptButton = datepickerContainer.getElementsByClassName("scrollroll-accept-button")[0]

    dayPicker = datepickerContainer.getElementsByClassName("scrollroll-day-picker")[0]
    monthPicker = datepickerContainer.getElementsByClassName("scrollroll-month-picker")[0]
    yearPicker = datepickerContainer.getElementsByClassName("scrollroll-year-picker")[0]

    addDayElements(dayPicker)
    addMonthElements(monthPicker)
    addYearElements(yearPicker)

    yearPos = allYears.length - 43
    previousYearScroll = scrollFromPos(yearPos)
    yearPicker.scrollTo(0, previousYearScroll)
    
    monthPos = Math.ceil(allMonthStrings.length / 2) - 1
    previousMonthScroll = scrollFromPos(monthPos)
    monthPicker.scrollTo(0, previousMonthScroll)

    daysPos = Math.floor(allDayStrings.length / 2) - 1
    previousDayScroll = scrollFromPos(daysPos)
    dayPicker.scrollTo(0, previousDayScroll)

    inputElement.addEventListener("click", inputElementClicked)
    inputElement.addEventListener("focus", inputElementFocused)
    acceptButton.addEventListener("click", acceptButtonClicked)
    return

############################################################
inputElementFocused = (evnt) ->
    log "inputElementFocused"
    evnt.preventDefault()
    this.blur()
    return false

acceptButtonClicked = (evnt) ->
    log "acceptButtonClicked"
    day = allDayStrings[dayPos]
    month = allMonthStrings[monthPos]
    year = allYears[yearPos]

    date = "#{year}-#{month}-#{day}"
    # inputValue = "#{day}.#{month}.#{year}"
    # inputElement.value = inputValue
    inputElement.value = date
    closeScrollRollDatepicker()
    return

inputElementClicked = (evnt) ->
    log "inputElementClicked"
    evnt.preventDefault()
    openScrollRollDatepicker()
    return false


closeScrollRollDatepicker = ->
    log "closeScrollRollDatepicker"
    datepickerContainer.classList.remove("shown")
    nexHeartbeat = () -> return
    return

openScrollRollDatepicker = ->
    log "openScrollRollDatepicker"
    datepickerContainer.classList.add("shown")

    nexHeartbeat = heartbeat
    requestAnimationFrame(nexHeartbeat)
    return

############################################################
#region adding scrollrollElements
addDayElements = (picker) ->
    log "addDayElements"
    html = "<div class='scrollroll-element-space'></div>"    
    for day in allDayStrings
        html += "<div class='scrollroll-element'>#{day}</div>"
    html += "<div class='scrollroll-element-space'></div>"
    picker.innerHTML = html
    return

addMonthElements = (picker) ->
    log "addMonthElements" 
    html = "<div class='scrollroll-element-space'></div>"
    for month in allMonthStrings
        html += "<div class='scrollroll-element'>#{month}</div>"
    html += "<div class='scrollroll-element-space'></div>"
    picker.innerHTML = html
    return

addYearElements = (picker) ->
    log "addYearElements"
    html = "<div class='scrollroll-element-space'></div>"
    for year in allYears
        html += "<div class='scrollroll-element'>#{year}</div>"
    html += "<div class='scrollroll-element-space'></div>"
    picker.innerHTML = html
    return

#endregion

############################################################
heartbeat = ->
    # log "heartbeat"
    checkDayScroll()
    checkMonthScroll()
    checkYearScroll()
    # setTimeout(heartbeat, 1000)
    requestAnimationFrame(nexHeartbeat)
    return

############################################################
previousDayScroll = 0
dayPos = 0

############################################################
checkDayScroll = ->
    # log "checkDayScroll"
    currentScroll = dayPicker.scrollTop 
    
    # log "scroll:  #{currentScroll}"
    # log "pos: #{dayPos}"

    posScroll = scrollFromPos(dayPos)
    ## when scroll did not change and we we are not on our valid scroll position
    if previousDayScroll == currentScroll and currentScroll != posScroll
        # then we snap to the next valid scroll position
        dayPos = posFromScroll(currentScroll)
        if dayPos > 30 then dayPos = 30 # 30 is last position
        currentScroll = scrollFromPos(dayPos)
        dayPicker.scrollTo(0, currentScroll)

    previousDayScroll = currentScroll
    return

############################################################
previousMonthScroll = 0
monthPos = 0

############################################################
checkMonthScroll = ->
    # log "checkMonthScroll"
    currentScroll = monthPicker.scrollTop 
    
    # log "scroll:  #{currentScroll}"
    # log "pos: #{monthPos}"

    posScroll = scrollFromPos(monthPos)
    ## when scroll did not change and we we are not on our valid scroll position
    if previousMonthScroll == currentScroll and currentScroll != posScroll
        # then we snap to the next valid scroll position
        monthPos = posFromScroll(currentScroll)
        if monthPos > 11 then monthPos = 11 # 11 is last position
        currentScroll = scrollFromPos(monthPos)
        monthPicker.scrollTo(0, currentScroll)

    previousMonthScroll = currentScroll
    return

############################################################
previousYearScroll = 0
yearPos = 0

############################################################
checkYearScroll = ->
    # log "checkYearScroll"
    currentScroll = yearPicker.scrollTop 
    
    # log "scroll:  #{currentScroll}"
    # log "pos: #{yearPos}"

    posScroll = scrollFromPos(yearPos)
    ## when scroll did not change and we we are not on our valid scroll position
    if previousYearScroll == currentScroll and currentScroll != posScroll
        # then we snap to the next valid scroll position
        yearPos = posFromScroll(currentScroll)
        if yearPos > 150 then yearPos = 150 # 150 is last position
        currentScroll = scrollFromPos(yearPos)
        yearPicker.scrollTo(0, currentScroll)

    previousYearScroll = currentScroll
    return


############################################################
scrollFromPos = (pos) -> (inputHeight / 2) + (pos * inputHeight)
posFromScroll = (scroll) -> (scroll - ( scroll % inputHeight)) / inputHeight 