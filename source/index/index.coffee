import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

global.allModules = Modules

import { ScrollRollDatepicker } from "./scrollrolldatepickermodule.js"
############################################################
inputId = "login-birthday-input"
otherId = "other-birthday-input"

############################################################
appStartup = ->
    ## which modules shall be kickstarted?
    element = inputId
    firstDatePicker = new ScrollRollDatepicker({element})
    firstDatePicker.initialize()
    
    element = otherId
    secondDatePicker = new ScrollRollDatepicker({element})
    secondDatePicker.initialize()
    return

############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appStartup()

############################################################
run()