<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use App\Indicator;
use App\Form;
use App\Form_item;

class workcmd extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'workcmd:sql';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Test generate SQL';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        echo '****';
        /*
        DB::table('forms')
            ->where('id', 3)
            ->update(['columns' => NULL]);
        */
        $id = 3;
        $rc = DB::select('select * from form_build_data(:form_id, :params)', ['form_id' => 3, 'params' => NULL]);
        $x = DB::table('forms')
            ->select(DB::raw('columns as total_sales'))
            ->find(3);
        $columns = DB::select('with x as (select unnest(columns) as r from forms where id = :id) '.
                        'select visible_(r), expr_(r), as_(r), title_(r), css_(r) from x',
                    ['id' => $id]);
        $rows = DB::select('with x as (select unnest(rows) as r from forms where id = :id) '.
            'select num_(r), expr_(r), as_(r) from x',
            ['id' => $id]);

        $items = DB::select('with x as (select num, unnest(columns) as r from form_items where form_id = :form_id) '.
            'select visible_(r), expr_(r), as_(r), title_(r), css_(r),  num_(r) as num_ from x order by num, num_',
            ['form_id' => $id]);

        foreach($items as $item) {
            echo "\n".$item->expr_;
        }


     $rc = DB::statement('select create_temp_indicators()');

        $rc = DB::table('temp_indicators')->insert([
            ['id' => 1, 'valend' => 10],
            ['id' => 2, 'valend' => 210]
        ]);
        $rc = DB::table('temp_indicators')->get();
        $rc = DB::statement('truncate table temp_indicators');

//        DB::insert(
/*
insert into temp_indicators (id) values (1)
select * from temp_indicators;
*/

//        DB::statement('CREATE OR REPLACE TEMP TABLE tmp_indicators ( '
//       statement(string $query, array $bindings = array())
//      DB::'CREATE OR REPLACE TEMP UNLOGGED TABLE [ IF NOT EXISTS ] имя_таблицы ( ['
//        $columns = $form->columns;
//        $x = DB::select('select \''.$columns.'\' as columns');
        //$results = DB::select('select * from users where id = :id', ['id' => 1]); ::form_columns
        //select (unnest(columns)).expr_, visible_(unnest(columns)) as a from forms WHERE id = 3;
        //
    }
}
