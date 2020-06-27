if Meteor.isClient
    Router.route '/events', (->
        @layout 'layout'
        @render 'events'
        ), name:'events'
    Router.route '/event/:doc_id/edit', (->
        @layout 'layout'
        @render 'event_edit'
        ), name:'event_edit'
    Router.route '/event/:doc_id/view', (->
        @layout 'layout'
        @render 'event_view'
        ), name:'event_view'

    Template.event_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.event_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id



    Template.events.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'event'
        @autorun => Meteor.subscribe 'all_users'

    Template.events.helpers
        events: ->
            Docs.find
                model:'event'
        users: ->
            Meteor.users.find({credit:$gt:1},
                sort:credit:-1)

    Template.events.events
        'click .add_event': ->
            new_id =
                Docs.insert
                    model:'event'
            Router.go "/event/#{new_id}/edit"


# if Meteor.isServer
#     Meteor.methods
        # refresh_global_stats: ->
        #     found_stats = Docs.findOne
        #         model:'stats'
        #     if found_stats
        #         fsd = found_stats
        #     else
        #         new_id =
        #             Docs.insert
        #                 model:'stats'
        #         fsd = Docs.findOne new_id
        #
        #     total_doc_count = Docs.find({}).count()
        #     total_item_count = Docs.find({model:'item'}).count()
        #     total_sales_count =
        #         Docs.find(
        #             model:'item'
        #             bought:true
        #             ).count()
        #
        #     total_selling_count =
        #         Docs.find(
        #             model:'item'
        #             bought:$ne:true
        #             ).count()
        #     total_deposits =
        #         Docs.find(
        #             model:'deposit'
        #         )
        #     total_deposit_count =
        #         Docs.find(
        #             model:'deposit'
        #         ).count()
        #
        #     total_deposit_amount = 0
        #     for deposit in total_deposits.fetch()
        #         total_deposit_amount += deposit.deposit_amount
        #
        #     total_withdrawals =
        #         Docs.find(
        #             model:'withdrawal'
        #         )
        #     total_withdrawal_count =
        #         Docs.find(
        #             model:'withdrawal'
        #         ).count()
        #
        #     total_withdrawal_amount = 0
        #     for withdrawal in total_withdrawals.fetch()
        #         total_withdrawal_amount += withdrawal.amount
        #
        #     total_site_profit = total_deposit_amount-total_withdrawal_amount
        #
        #     Docs.update fsd._id,
        #         $set:
        #             total_doc_count:total_doc_count
        #             total_item_count:total_item_count
        #             total_selling_count:total_selling_count
        #             total_sales_count:total_sales_count
        #             total_deposit_count: total_deposit_count
        #             total_deposit_amount: total_deposit_amount
        #             total_withdrawal_amount: total_withdrawal_amount
        #             total_site_profit: total_site_profit
