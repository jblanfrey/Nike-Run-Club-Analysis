function saveData()
  
  arguments
    %     activityID (1,1) string = "0b5b944d-2569-4d0c-b7a8-913108ecfb8d";
  end
  
  %% The key keeps changing so you have to get it using development tools in Google Chrome
  %TODO: can we grab the key automatically?
  authenticationKey = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImFlYmJkMWMyLTNjNDUtNDM5NS04MGMzLWE3YTIyMmJlOTJmMHNpZyJ9.eyJ0cnVzdCI6MTAwLCJpYXQiOjE1OTI5MTM4ODQsImV4cCI6MTU5MjkxNzQ4NCwiaXNzIjoib2F1dGgyYWNjIiwianRpIjoiYTM2NGJiMzMtODE2Ni00MzdjLTljODAtZjZiY2Q2ZjUxMTVkIiwibGF0IjoxNTkyOTEzODg0LCJhdWQiOiJjb20ubmlrZS5kaWdpdGFsIiwic3ViIjoiY29tLm5pa2UuY29tbWVyY2UubmlrZWRvdGNvbS53ZWIiLCJzYnQiOiJuaWtlOmFwcCIsInNjcCI6WyJuaWtlLmRpZ2l0YWwiXSwicHJuIjoiMTUwMjc4MTE5NTkiLCJwcnQiOiJuaWtlOnBsdXMifQ.Xp7rQmMIAa6h-R-1I1l3dYPbsVtGt1uN_AY4KoKRUdw-o2869b1bYiACDObW2TNYM0YXy2VFWv97uI-_GjTJkFkA-DqtOoNbCOWBM0kit938NigU4WrcEjOLxbAJLlhiPtQzbsBpeH3BUegRuastfD8N-5fxOfofOTbHXqUn_EbN0iC0DD9Vp3yDtXmNQSgCVlbnXDO5cktm447nE8pDbLI--nQo6yCv-yvmmEd6wOvHpiTqLxMJ6YTX-8KDNIXbbJhXMxAj2nbAkWJznXouTuxuPXvnka61rCBhl8dUgiSDWy8s9pM9wg-hP6f57SStGvlgrraVXt-tKVpBuPvM7g";
  
  %%
  % This header data is used for all the requests
  headerData = matlab.net.http.HeaderField("Authorization","Bearer " + authenticationKey);
  request = matlab.net.http.RequestMessage;
  request.Header = headerData;
  
  url = "https://api.nike.com/sport/v3/me/activities/after_time/0";
  nextActivitiesID = saveActivities(request, url);
  
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
