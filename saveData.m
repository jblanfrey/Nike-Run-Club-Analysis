function saveData()
  
  arguments
    %     activityID (1,1) string = "0b5b944d-2569-4d0c-b7a8-913108ecfb8d";
  end
  
  %% The key keeps changing so you have to get it using development tools in Google Chrome
  %TODO: can we grab the key automatically?
  authenticationKey = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImFlYmJkMWMyLTNjNDUtNDM5NS04MGMzLWE3YTIyMmJlOTJmMHNpZyJ9.eyJ0cnVzdCI6MTAwLCJpYXQiOjE1OTM0NzM1NzcsImV4cCI6MTU5MzQ3NzE3NywiaXNzIjoib2F1dGgyYWNjIiwianRpIjoiZWE4MWRlN2EtOGM3OC00NjJlLTgzNTYtZTExM2U0NjFhMWMxIiwibGF0IjoxNTkzNDczNTc3LCJhdWQiOiJjb20ubmlrZS5kaWdpdGFsIiwic3ViIjoiY29tLm5pa2UuY29tbWVyY2UubmlrZWRvdGNvbS53ZWIiLCJzYnQiOiJuaWtlOmFwcCIsInNjcCI6WyJuaWtlLmRpZ2l0YWwiXSwicHJuIjoiMTUwMjc4MTE5NTkiLCJwcnQiOiJuaWtlOnBsdXMifQ.jh5gKBw5rVWeXLQwITHteuAc03Y-562KDFew8JxBdnu_MYDBiifxJbFllbqItYVjNmKQOGp--iSMGyJfR60piGH9PUexnBs8dxxVrYUqODDLafmpo4eFvhVbPHbwoa8zE8788mmqpXdBxUJpOqvZUYQ2EpPR0EklLOWL6eeGUDmkPyGrSuQdZFnfx6qcCsllvtIQHZ6D0MQ4U_AMAJX2LBHfA1gW2aoVYS_12uEAzwZDD5HoM2SeZCYPug92VCV5sqt9kjbQsjTLSzVzhatbrwbYkFTmVKiOi1AtYcH6vCR2aJRW8RCW_x_o5Wzt_SyATTsFCaDRpoxei-Vl37Entw";
  
  %%
  % This header data is used for all the requests
  headerData = matlab.net.http.HeaderField("Authorization","Bearer " + authenticationKey);
  request = matlab.net.http.RequestMessage;
  request.Header = headerData;
  
  
  if isempty(dir("data/*.mat"))
    url = "https://api.nike.com/sport/v3/me/activities/after_time/0";
    nextActivitiesID = saveActivities(request, url);
  end
  
  % use last run as a starting point to download additional workouts
  list = dir("data/*.mat");
  load(list(end).name);
  nextActivitiesID = data.id;
  
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
