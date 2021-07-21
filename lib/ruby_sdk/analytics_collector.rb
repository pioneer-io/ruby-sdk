# class to handle connections to Google Analytics account
class AnalyticsCollector
	def initialize(config_object)
		@tracking_id = config_object[:tracking_id]
		@client_id = config_object[:client_id]
	end

	def log_event(event_object)
		client_id = event_object[:client_id]

		puts 'event object in log_event', event_object

		Net::HTTP.post_form(
			URI("http://www.google-analytics.com/collect"),
			v:   "1",             # API Version
			tid: @tracking_id,    # Tracking ID / Property ID
			cid: @client_id,       # Client ID
			t:   "event",         # Event hit type
			ec:  event_object[category],        # Event category
			ea:  event_object[action],          # Event action
			el:  event_object[label],           # Event label
			ev:  event_object[value]            # Event value
		)
	end
end