@Demo.module "LeadsApp.List", (List, App, Backbone, Marionette, $, _) ->
        class List.Leads extends Marionette.ItemView
                template: "leads/list/templates/leads"
