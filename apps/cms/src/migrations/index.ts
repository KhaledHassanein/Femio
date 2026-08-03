import * as migration_20260803_123841_baseline_existing_schema from './20260803_123841_baseline_existing_schema';
import * as migration_20260803_123901_p1_6_6_publishing_fields from './20260803_123901_p1_6_6_publishing_fields';

export const migrations = [
  {
    up: migration_20260803_123841_baseline_existing_schema.up,
    down: migration_20260803_123841_baseline_existing_schema.down,
    name: '20260803_123841_baseline_existing_schema',
  },
  {
    up: migration_20260803_123901_p1_6_6_publishing_fields.up,
    down: migration_20260803_123901_p1_6_6_publishing_fields.down,
    name: '20260803_123901_p1_6_6_publishing_fields'
  },
];
