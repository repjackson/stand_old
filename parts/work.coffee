if Meteor.isClient
    Router.route '/work', (->
        @layout 'layout'
        @render 'work'
        ), name:'work'
    Router.route '/work/:doc_id/edit', (->
        @layout 'layout'
        @render 'work_edit'
        ), name:'work_edit'


    Template.work.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'work'
        @autorun -> Meteor.subscribe('work',
            selected_tags.array()
            Session.get('view_complete')
            Session.get('view_incomplete')
            )
        @autorun => Meteor.subscribe 'model_docs', 'work_stats'
        @autorun => Meteor.subscribe 'current_work'
    Template.work.events
        'click .toggle_complete': ->
            Session.set('view_complete', !Session.get('view_complete'))
        'click .new_work': (e,t)->
            new_work_id =
                Docs.insert
                    model:'work'
            Session.set('editing_work', true)
            Session.set('selected_work_id', new_work_id)
        'click .unselect_work': ->
            Session.set('selected_work_id', null)

    Template.work.helpers
        view_complete_class: ->
            if Session.get('view_complete') then 'blue' else ''
        selected_work_doc: ->
            Docs.findOne Session.get('selected_work_id')
        current_work: ->
            Docs.find
                model:'work'
                current:true
        work_stats_doc: ->
            Docs.findOne
                model:'work_stats'
        work: ->
            Docs.find
                model:'work'




    Template.selected_work.events
        'click .delete_work': ->
            if confirm 'delete work?'
                Docs.remove @_id
                Session.set('selected_work_id', null)
        'click .save_work': ->
            Session.set('editing_work', false)
        'click .edit_work': ->
            Session.set('editing_work', true)
        'click .goto_work': (e,t)->
            console.log @
            $(e.currentTarget).closest('.grid').transition('fade right', 500)
            Meteor.setTimeout =>
                Router.go "/work/#{@_id}/view"
            , 500

    Template.selected_work.helpers
        editing_work: -> Session.get('editing_work')










    Template.work_card_template.onRendered ->
        Meteor.setTimeout ->
            $('.accordion').accordion()
        , 1000
    Template.work_card_template.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'log_events'
    Template.work_card_template.events
        'click .add_work_item': ->
            new_mi_id = Docs.insert
                model:'work_item'
            Router.go "/work/#{_id}/edit"
    Template.work_card_template.helpers
        work_segment_class: ->
            cl=''
            if @complete
                classes += ' green'
            if Session.equals('selected_work_id', @_id)
                classes += ' inverted blue'
            classes
        work_list: ->
            # console.log @
            Docs.findOne
                model:'work_list'
                _id: @work_list_id


    Template.work_card_template.events
        'click .select_work': ->
            if Session.equals('selected_work_id',@_id)
                Session.set 'selected_work_id', null
            else
                Session.set 'selected_work_id', @_id
        'click .goto_work': (e,t)->
            console.log @
            $(e.currentTarget).closest('.grid').transition('fade right', 500)
            Meteor.setTimeout =>
                Router.go "/work/#{@_id}/view"
            , 500







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
    Meteor.publish 'work', (
        selected_tags
        view_complete
        )->
        # user = Meteor.users.findOne @userId
        # console.log selected_tags
        # console.log filter
        self = @
        match = {}
        if view_complete
            match.complete = true
        # if Meteor.user()
        #     unless Meteor.user().roles and 'dev' in Meteor.user().roles
        #         match.view_roles = $in:Meteor.user().roles
        # else
        #     match.view_roles = $in:['public']

        # if filter is 'shop'
        #     match.active = true
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        # if filter then match.model = filter
        match.model = 'work'

        Docs.find match, sort:_timestamp:-1
