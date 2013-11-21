if Stashing.enabled
  Stashing.add_custom_fields do |fields|
    fields[:user_id] = current_user.id
    fields[:session_id] = session[:session_id]
    fields[:request_id] = request.uuid
  end

  Stashing.watch('sql.active_record') do |name, start, finish, id, payload, stash|
    duration = (finish - start) * 1000
    stash[:queries] = stash[:queries].to_i.succ
    if stash[:slowest_query].to_i < duration
      stash[:slowest_query] = duration
    end
  end

  Stashing.watch('cache_fetch_hit.active_support', event_group: 'cache') do |*args, stash|
    stash[:fetch_hit] = stash[:fetch_hit].to_i.succ
  end

  Stashing.watch('cache_generate.active_support', event_group: 'cache') do |*args, stash|
    stash[:generate] = stash[:generate].to_i.succ
  end
end
