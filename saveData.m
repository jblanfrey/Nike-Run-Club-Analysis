function saveData()
  
  arguments
    %     activityID (1,1) string = "0b5b944d-2569-4d0c-b7a8-913108ecfb8d";
  end
  
  %% The key keeps changing so you have to get it using development tools in Google Chrome
  %TODO: can we grab the key automatically?
  authenticationKey = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImFlYmJkMWMyLTNjNDUtNDM5NS04MGMzLWE3YTIyMmJlOTJmMHNpZyJ9.eyJ0cnVzdCI6MTAwLCJpYXQiOjE1OTM2Njk3NTQsImV4cCI6MTU5MzY3MzM1NCwiaXNzIjoib2F1dGgyYWNjIiwianRpIjoiNWU0NTE0NjEtNmE5Yy00NDYxLWI0ZTUtNTc4MmM3NmZiM2Q1IiwibGF0IjoxNTkzNjY5NzU0LCJhdWQiOiJjb20ubmlrZS5kaWdpdGFsIiwic3ViIjoiY29tLm5pa2UuY29tbWVyY2UubmlrZWRvdGNvbS53ZWIiLCJzYnQiOiJuaWtlOmFwcCIsInNjcCI6WyJuaWtlLmRpZ2l0YWwiXSwicHJuIjoiMTUwMjc4MTE5NTkiLCJwcnQiOiJuaWtlOnBsdXMifQ.0C1ppgIHbddK8x8WB7rUS3V8pS66hOT7iHOHNW1jKDgMa3-6GHfZ7ULJzd0xZ-M-6CyE9xt3iCIDP-bbK6IzO8vs8yD8mLQOwmiWOmOVAnh_KUXovInJKLCHW4FiytPZBgW4KFVH-Q8V6f-vEfXIl8AuTw6imZ4nLd20uEebGKBlkHmUzUTgNxliXL7IG_qnV0NkkDQTPA249PGgNM2QS_g9LBZq9JLOXCBf12XXbLzCuuZMg3x1kZyQMpX5c18hL_n1ywCiprNV9Egxfrq88yb7sDByV8nnXfPge1nKHHIs4GN98PNs1vseQl0EtE6v3ijFWlKsqX3is4ZeCXvg4Q";
  
  %%
  % This header data is used for all the requests
  headerData = matlab.net.http.HeaderField("Authorization","Bearer " + authenticationKey);
  request = matlab.net.http.RequestMessage;
  request.Header = headerData;
  
  
  if isempty(dir("data/*.mat"))
    url = "https://api.nike.com/sport/v3/me/activities/after_time/0";
    nextActivitiesID = saveActivities(request, url);
  else
    % use last run as a starting point to download additional workouts
    list = dir("data/*.mat");
    load(list(end).name);
    nextActivitiesID = data.id;
  end
  
  while ~isempty(nextActivitiesID)
    url = "https://api.nike.com/sport/v3/me/activities/after_id/" + nextActivitiesID;
    nextActivitiesID = saveActivities(request, url);
  end
end

function nextActivitiesID = saveActivities(request, url)
  response = send(request,url);
  activities = response.Body.Data.activities;
  try
    nextActivitiesID = response.Body.Data.paging.after_id;
  catch
    nextActivitiesID = [];
  end
  
  for k=1:numel(activities)
    try
      activityID = activities{k}.id;
    catch
      activityID = activities(k).id;
    end
    url = matlab.net.URI("https://api.nike.com/sport/v3/me/activity/" + activityID + "?metrics=ALL");
    activity = send(request,url);
    
    data = activity.Body.Data;
    d = datetime(data.start_epoch_ms/1000, 'convertfrom', 'posixtime', 'Format', 'yyyyMMdd-HHmmss', 'TimeZone', 'UTC');
    d.TimeZone = 'Australia/Sydney';
    filename = "activity-" + string(d);
    save("data/" + filename, "data");
  end
end
