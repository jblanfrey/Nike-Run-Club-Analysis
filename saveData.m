function saveData()
  
  arguments
    %     activityID (1,1) string = "0b5b944d-2569-4d0c-b7a8-913108ecfb8d";
  end
  
  %% The key keeps changing so you have to get it using development tools in Google Chrome
  %TODO: can we grab the key automatically?
  authenticationKey = ""; % put your key here
  
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
