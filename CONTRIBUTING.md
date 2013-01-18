# Contributing to Dossier

All contributions to Dossier must come well-tested.

## Adapters

Dossier currently has `Dossier::Adapter::ActiveRecord`, which allows it to get an ActiveRecord connection and use it for escaping queries, and executing them. It wraps the returned result object in a `Dossier::Adapter::ActiveRecord::Result`, which simply provides a standard way of getting headers and rows.

If you'd like to add the ability to use a different ORM's connections, you'd need to add a new adapter class and a new adapter result class.

You'd also need to update `Client#loaded_orms` to check for the presence of your ORM.
