import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

global.allModules = Modules

############################################################
inputId = "login-birthday-input"
otherId = "other-birthday-input"

############################################################
appStartup = ->
    ## which modules shall be kickstarted?
    Modules.scrollrolldatepickermodule.setUp(inputId)
    # Modules.scrollrolldatepickermodule.setUp(otherId)
    return

############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appStartup()

############################################################
run()