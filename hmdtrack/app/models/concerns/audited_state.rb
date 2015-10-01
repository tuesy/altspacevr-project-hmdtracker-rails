require 'active_support/concern'

module AuditedState
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    # is_audited_state_for :hmd
    def is_audited_state_for(klass)
      class_attribute :parent_state_class
      self.parent_state_class = klass
    end

    # has_audited_state_through :hmd_states, [:announced, :devkit, :released]
    def has_audited_state_through(table, states)

    end
  end
end
