############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("smoothanimationmodule")
#endregion

############################################################
allTasks = new Set()
allTasksArray = []


############################################################
export initialize = ->
    log "initialize"
    requestAnimationFrame(heartbeat)
    return

############################################################
heartbeat = ->
    log "heartbeat"
    task() for task in allTasksArray
    requestAnimationFrame(heartbeat)
    return

############################################################
export addAnimationTask = (task) ->
    log "addAnimationTask"
    allTasks.add(task)
    allTasksArray = [...allTasks]
    log "number of Tasks now: #{allTasksArray.length}"
    return

############################################################
export removeAnimationTask = (task) ->
    log "addAnimationTask"
    allTasks.delete(task)
    allTasksArray = [...allTasks]
    log "number of Tasks now: #{allTasksArray.length}"
    return