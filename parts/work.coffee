if Meteor.isClient
    Router.route '/work', (->
        @layout 'layout'
        @render 'work'
        ), name:'work'


    Template.work.onCreated ->
        @autorun -> Meteor.subscribe('work_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            selected_tribes.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('work_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            selected_tribes.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
    Template.work.events
        'click .toggle_complete': ->
            Session.set('view_complete', !Session.get('view_complete'))
        'click .new_work': (e,t)->
            new_work_id =
                Docs.insert
                    model:'work'
            Router.go "/work/#{new_work_id}/edit"

    Template.work.helpers
        view_complete_class: ->
            if Session.get('view_complete') then 'blue' else ''
        work_docs: ->
            Docs.find
                model:'work'




    Template.work_card_template.onRendered ->
    Template.work_card_template.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'log_events'
    Template.work_card_template.events
    Template.work_card_template.helpers
        work_segment_class: ->
            cl=''
            if @complete
                classes += ' green'
            if Session.equals('selected_work_id', @_id)
                classes += ' inverted blue'
            classes


    Template.work_card_template.events





if Meteor.isServer
    Meteor.methods
        refresh_work_stats: (work_id)->
            work = Docs.findOne work_id
            # console.log work
            reservations = Docs.find({model:'reservation', work_id:work_id})
            reservation_count = reservations.count()
            total_earnings = 0
            total_work_hours = 0
            average_work_duration = 0

            # shorwork_reservation =
            # longest_reservation =

            for res in reservations.fetch()
                total_earnings += parseFloat(res.cost)
                total_work_hours += parseFloat(res.hour_duration)

            average_work_cost = total_earnings/reservation_count
            average_work_duration = total_work_hours/reservation_count

            Docs.update work_id,
                $set:
                    reservation_count: reservation_count
                    total_earnings: total_earnings.toFixed(0)
                    total_work_hours: total_work_hours.toFixed(0)
                    average_work_cost: average_work_cost.toFixed(0)
                    average_work_duration: average_work_duration.toFixed(0)

            # .ui.small.header total earnings
            # .ui.small.header work ranking #reservations
            # .ui.small.header work ranking $ earned
            # .ui.small.header # different renters
            # .ui.small.header avg work time
            # .ui.small.header avg daily earnings
            # .ui.small.header avg weekly earnings
            # .ui.small.header avg monthly earnings
            # .ui.small.header biggest renter
            # .ui.small.header predicted payback duration
            # .ui.small.header predicted payback date
