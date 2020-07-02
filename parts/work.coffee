if Meteor.isClient
    Router.route '/generate', (->
        @layout 'layout'
        @render 'generate'
        ), name:'generate'


    Template.generate.onCreated ->
        @autorun -> Meteor.subscribe('generate_tag_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            selected_tribes.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
        @autorun -> Meteor.subscribe('generate_results',
            selected_tags.array()
            selected_location_tags.array()
            selected_authors.array()
            selected_tribes.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
    Template.generate.events

        # 'click .toggle_complete': ->
        #     Session.set('view_complete', !Session.get('view_complete'))
        'click .new_generate': (e,t)->
            new_generate_id =
                Docs.insert
                    model:'generate'
            Router.go "/generate/#{new_generate_id}/edit"

    Template.generate.helpers
        view_complete_class: ->
            if Session.get('view_complete') then 'blue' else ''
        generate_docs: ->
            Docs.find
                model:'generate'




    Template.generate_card_template.onRendered ->
    Template.generate_card_template.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'log_events'
    Template.generate_card_template.events
    Template.generate_card_template.helpers
        # generate_segment_class: ->
        #     cl=''
        #     if @complete
        #         classes += ' green'
        #     if Session.equals('selected_generate_id', @_id)
        #         classes += ' inverted blue'
        #     classes


    Template.generate_card_template.events
        'click .record_generate': ->
            console.log 'hi'
            Meteor.users.update Meteor.userId(),
                $inc: points:@points
            $('body')
              .toast({
                class: 'success'
                position: 'bottom right'
                message: "#{@points} added to account"
              })




if Meteor.isServer
    Meteor.methods
        refresh_generate_stats: (generate_id)->
            generate = Docs.findOne generate_id
            # console.log generate
            reservations = Docs.find({model:'reservation', generate_id:generate_id})
            reservation_count = reservations.count()
            total_earnings = 0
            total_generate_hours = 0
            average_generate_duration = 0

            # shorgenerate_reservation =
            # longest_reservation =

            for res in reservations.fetch()
                total_earnings += parseFloat(res.cost)
                total_generate_hours += parseFloat(res.hour_duration)

            average_generate_cost = total_earnings/reservation_count
            average_generate_duration = total_generate_hours/reservation_count

            Docs.update generate_id,
                $set:
                    reservation_count: reservation_count
                    total_earnings: total_earnings.toFixed(0)
                    total_generate_hours: total_generate_hours.toFixed(0)
                    average_generate_cost: average_generate_cost.toFixed(0)
                    average_generate_duration: average_generate_duration.toFixed(0)

            # .ui.small.header total earnings
            # .ui.small.header generate ranking #reservations
            # .ui.small.header generate ranking $ earned
            # .ui.small.header # different renters
            # .ui.small.header avg generate time
            # .ui.small.header avg daily earnings
            # .ui.small.header avg weekly earnings
            # .ui.small.header avg monthly earnings
            # .ui.small.header biggest renter
            # .ui.small.header predicted payback duration
            # .ui.small.header predicted payback date
