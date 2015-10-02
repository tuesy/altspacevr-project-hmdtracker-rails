require 'active_support/concern'

module AuditedState
  extend ActiveSupport::Concern

  class_methods do
    # is_audited_state_for :hmd
    def is_audited_state_for(klass, options={})
      class_attribute :audited_state_class
      self.audited_state_class = klass
      belongs_to klass # belongs_to :hmd
    end

    # has_audited_state_through :hmd_states, [:announced, :devkit, :released]
    def has_audited_state_through(table, states, options={})
      class_attribute :audited_state_table
      self.audited_state_table = table
      has_many table # has_many :hmd_states

      class_attribute :audited_states
      self.audited_states = states

      send :include, AuditedClassInstanceMethods

      attr_accessor :audited_state

      # custom validations
      validate :validates_audited_state_with_exception

      # life-cycle hooks
      after_save :create_audited_state_record
    end
  end

  # these are specific to the class that has the audited state field
  module AuditedClassInstanceMethods
    def state
      # e.g @hmd.hmd_states...
      self.send(self.class.audited_state_table).order('created_at DESC').first.try(:state).try(:to_sym) || self.class.audited_states.first
    end

    # should always return a symbol
    def state=(input)
      self.audited_state = input.try(:to_sym)
    end

    def validates_audited_state_with_exception
      unless self.audited_state && self.class.audited_states.include?(self.audited_state)
        raise RuntimeError.new('invalid state')
      end
    end

    # should be noisy if it fails
    def create_audited_state_record
      # e.g. @hmd.hmd_states.create!(state: self.state)
      self.send(self.class.audited_state_table).create!(state: self.audited_state)
    end
  end
end
