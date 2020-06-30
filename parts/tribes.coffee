if Meteor.isClient
    Router.route '/tribes', (->
        @layout 'layout'
        @render 'tribes'
        ), name:'tribes'


    Template.tribes.onCreated ->
        @autorun -> Meteor.subscribe('tribe_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            selected_tribes.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('tribe_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            selected_tribes.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
    Template.tribes.events
        # 'click .toggle_complete': ->
        #     Session.set('view_complete', !Session.get('view_complete'))
        'click .new_tribe': (e,t)->
            new_tribe_id =
                Docs.insert
                    model:'tribe'
            Router.go "/tribe/#{new_tribe_id}/edit"

    Template.tribes.helpers
        view_complete_class: ->
            if Session.get('view_complete') then 'blue' else ''
        tribe_docs: ->
            Docs.find
                model:'tribe'




    Template.tribe_card_template.onRendered ->
    Template.tribe_card_template.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'log_events'
    Template.tribe_card_template.events
    Template.tribe_card_template.helpers
        # tribe_segment_class: ->
        #     cl=''
        #     if @complete
        #         classes += ' green'
        #     if Session.equals('selected_tribe_id', @_id)
        #         classes += ' inverted blue'
        #     classes


    Template.tribe_card_template.events





if Meteor.isServer
    Meteor.methods
        refresh_tribe_stats: (tribe_id)->
            tribe = Docs.findOne tribe_id
            # console.log tribe
            reservations = Docs.find({model:'reservation', tribe_id:tribe_id})
            reservation_count = reservations.count()
            total_earnings = 0
            total_tribe_hours = 0
            average_tribe_duration = 0

            # shortribe_reservation =
            # longest_reservation =

            for res in reservations.fetch()
                total_earnings += parseFloat(res.cost)
                total_tribe_hours += parseFloat(res.hour_duration)

            average_tribe_cost = total_earnings/reservation_count
            average_tribe_duration = total_tribe_hours/reservation_count

            Docs.update tribe_id,
                $set:
                    reservation_count: reservation_count
                    total_earnings: total_earnings.toFixed(0)
                    total_tribe_hours: total_tribe_hours.toFixed(0)
                    average_tribe_cost: average_tribe_cost.toFixed(0)
                    average_tribe_duration: average_tribe_duration.toFixed(0)

            # .ui.small.header total earnings
            # .ui.small.header tribe ranking #reservations
            # .ui.small.header tribe ranking $ earned
            # .ui.small.header # different renters
            # .ui.small.header avg tribe time
            # .ui.small.header avg daily earnings
            # .ui.small.header avg weekly earnings
            # .ui.small.header avg monthly earnings
            # .ui.small.header biggest renter
            # .ui.small.header predicted payback duration
            # .ui.small.header predicted payback date
