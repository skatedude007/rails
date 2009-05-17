require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

module Arel
  describe Group do
    before do
      @relation = Table.new(:users)
      @attribute = @relation[:id]
    end

    describe '#to_sql' do
      describe 'when given a predicate' do
        it "manufactures sql with where clause conditions" do
          sql = Group.new(@relation, @attribute).to_sql

          adapter_is :mysql do
            sql.should be_like(%Q{
              SELECT `users`.`id`, `users`.`name`
              FROM `users`
              GROUP BY `users`.`id`
            })
          end

          adapter_is_not :mysql do
            sql.should be_like(%Q{
              SELECT "users"."id", "users"."name"
              FROM "users"
              GROUP BY "users"."id"
            })
          end
        end
      end

      describe 'when given a string' do
        it "passes the string through to the where clause" do
          sql = Group.new(@relation, 'asdf').to_sql

          adapter_is :mysql do
            sql.should be_like(%Q{
              SELECT `users`.`id`, `users`.`name`
              FROM `users`
              GROUP BY asdf
            })
          end

          adapter_is_not :mysql do
            sql.should be_like(%Q{
              SELECT "users"."id", "users"."name"
              FROM "users"
              GROUP BY asdf
            })
          end
        end
      end
    end
  end
end