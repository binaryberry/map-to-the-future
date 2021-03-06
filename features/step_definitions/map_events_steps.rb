Then(/^I see a map$/) do
  expect(page).to have_css('.leaflet-container')
end

Given(/^the Timeline app knows The Battle of Dresden Anniversary$/) do
  point_event("The Battle of Dresden Anniversary", "This is the short description",
    "Marshall Saint-Cyr defends Dresden from the Allied assault, and is relieved by Napoleon and the dashing Marshall Murat, who inflict a heavy defeat on the Austrians but fail to pursue due to Napoleon's ill-health",
    ["Battle"], 1913, 1913, "year", [13.733333, 51.033333], [])

end

When(/^I move the slider to "(.*?)"$/) do |year|
  sleep(3)
  page.execute_script("$('#slider').slider('option', 'programmatic', true)")
  page.execute_script("$('#slider').slider('value', #{year})")
  page.execute_script("$('#slider').slider('option', 'programmatic', false)")
  sleep(3)
end

When(/^I click on the marker$/) do
  sleep(3)
  page.execute_script("eventLayer.eachLayer(function(marker) { marker.openPopup() });")
  sleep(3)
end

Then(/^I should see a marker$/) do
  sleep(3)
  expect(page).to have_css('img.leaflet-marker-icon')
  sleep(3)
end

Then(/^I should not see a marker$/) do
  sleep(3)
  expect(page.evaluate_script("Object.keys(eventLayer._layers).length")).to eq(0)
  sleep(3)
end

Then(/^I should see no zoom buttons$/) do
  sleep(3)
  expect(page).not_to have_css('.leaflet-control-zoom-out')
  expect(page).not_to have_css('.leaflet-control-zoom-in')
  sleep(3)
end

def point_event(name, short_description, description, tags, start_date, end_date, timescale, coords, events)
  Event.create({title: name,
                short_description: short_description,
                description: description,
                tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                startdate: DateTime.new(start_date),
                enddate: DateTime.new(end_date),
                geometry: { type: "Point", coordinates: coords },
                events: linkedevents
                })
end
