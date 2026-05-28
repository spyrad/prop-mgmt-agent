-- Properties table (FR-001): Immobilien-Objekte mit Owner-basiertem RLS
CREATE TABLE properties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  address text NOT NULL,
  property_type text,
  purchase_price numeric,
  purchase_costs numeric,
  nlw_date date,
  construction_year integer,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE INDEX idx_properties_user_id ON properties(user_id);

-- RLS: Owner-only access
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own properties"
  ON properties FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own properties"
  ON properties FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own properties"
  ON properties FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own properties"
  ON properties FOR DELETE
  USING (auth.uid() = user_id);

-- Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON properties
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
