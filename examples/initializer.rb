if Logtastic.enabled
  Logtastic.add_custom_fields do |fields|
    fields[:user_id] = current_user.id
    fields[:session_id] = session[:session_id]
    fields[:request_id] = request.uuid
  end

  Logtastic.watch('sql.active_record') do |name, start, finish, id, payload, event_store|
    duration = (finish - start) * 1000
    event_store[:queries] = event_store[:queries].to_i.succ
    if event_store[:slowest_query].to_i < duration
      event_store[:slowest_query] = duration
    end
  end

  Logtastic.watch('cache_fetch_hit.active_support', event_group: 'cache') do |*args, event_store|
    event_store[:fetch_hit] = event_store[:fetch_hit].to_i.succ
  end

  Logtastic.watch('cache_generate.active_support', event_group: 'cache') do |*args, event_store|
    event_store[:generate] = event_store[:generate].to_i.succ
  end
end
