class Conversion < ApplicationRecord
  belongs_to :sprint

  # Validations
  validate :xs_less_than_s
  validate :s_less_than_m
  validate :m_less_than_l
  validate :l_less_than_xl
  validate :xl_less_than_xxl
  validate :xs_less_than_xxl

  def xs_less_than_s
    errors.add(:conversion, "for XS must be less than S") if xs >= s
  end

  def s_less_than_m
    errors.add(:conversion, "for S must be less than M") if s >= m
  end

  def m_less_than_l
    errors.add(:conversion, "for M must be less than L") if m >= l
  end

  def l_less_than_xl
    errors.add(:conversion, "for L must be less than XL") if l >= xl
  end

  def xl_less_than_xxl
    errors.add(:conversion, "for XL must be less than XXL") if xl >= xxl
  end

  def xs_less_than_xxl
    errors.add(:conversion, "for XS must be less than XXL") if xs >= xxl
  end
end
