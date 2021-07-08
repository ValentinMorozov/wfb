<?php

namespace App\Http\Controllers;

use App\Indicator;
use App\Form;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;



class ReportsController extends Controller
{

    public function index()
    {

        if (Auth::check())
        {
            $forms = Form::Where('parent_id',0)
                ->select('id', 'parent_id', 'name', 'isfolder')
                ->orderBy('isfolder', 'desc')
                ->orderBy('name', 'asc')
                ->get();
            foreach($forms as $key => $formItem)
            {
                $forms[$key]->children = Form::Where('parent_id',$formItem->id)
                    ->select('id', 'parent_id', 'name', 'isfolder')
                    ->orderBy('isfolder', 'desc')
                    ->orderBy('name', 'asc')
                    ->get();
            }
        }
        else
            $forms = (object)[];
         return view('reports.index', compact('forms')/*, compact('plants_tree_path')*/);       //
    }

    public function AjaxGetData(Request $request)
    {
        $FormID = json_decode($request->input('form_id'));
        $Params = $request->input('params');
        $FormInfo = DB::select('SELECT  name, component, queryType, subFormsInfo FROM form_get_info(:form_id)', ['form_id' => $FormID]);
        if(count($FormInfo) == 1)
        {
            $result = '"FormName":'.'"'.$FormInfo[0]->name.'"'
                .',"FormComponent":'.'"'.$FormInfo[0]->component.'"'
                .',"SubFormsInfo":'.$FormInfo[0]->subformsinfo;

            $DataLoader = $FormInfo[0]->querytype.'GetData';            // Основной метод загрузки данных
            if(method_exists($this, $DataLoader)) {
                $this->$DataLoader($FormID, $Params, $result);
            }

            $DataLoader = $FormInfo[0]->component.'GetDataComp';        // Метод загрузки дополнительных данных для компонента
            if(method_exists($this, $DataLoader)) {
                $this->$DataLoader($FormID, $Params, $result);
            }
        }
        else $result = NULL;
        return response('{'.$result.'}');
    }
// Метод загрузки данных для crossTable
// $FormID - ID формы
// $Params - параметры выборки полученные от клиента
// &$result - переменная для формирования ответа (по ссылке)
    private function crossTableGetData($FormID, $Params, &$result)
    {
        $p = DB::select('select * from form_build_data(:form_id, :params)', ['form_id' => $FormID, 'params' => $Params]);
        if(count($p) == 1)
        {
            $result .= ',"Table":'.json_encode(DB::select($p[0]->o_sql_get_data))
                .',"Rows":'.$p[0]->o_def_rows
                .',"Cols":'.$p[0]->o_def_columns
                .',"Totals":'.$p[0]->o_totals
                .',"FormColumns":'.$p[0]->o_columns
                .',"FormRows":'.$p[0]->o_rows
                .',"FormProps":'.$p[0]->o_props;
        }
    }
/*    private function default_data(){

    }
*/
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
