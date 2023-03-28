############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("smoothanimationmodule")
#endregion

############################################################
allTasks = new Set()
allTasksArray = []
nexHeartbeat = () -> return

############################################################
heartbeat = ->
    # log "heartbeat"
    task() for task in allTasksArray
    requestAnimationFrame(nexHeartbeat)
    return

############################################################
export addAnimationTask = (task) ->
    log "addAnimationTask"
    allTasks.add(task)
    allTasksArray = [...allTasks]
    log "number of Tasks now: #{allTasksArray.length}"
    nexHeartbeat = heartbeat
    return

############################################################
export removeAnimationTask = (task) ->
    log "addAnimationTask"
    allTasks.delete(task)
    allTasksArray = [...allTasks]
    log "number of Tasks now: #{allTasksArray.length}"
    if allTasksArray.length == 0 then nexHeartbeat = () -> return
    return