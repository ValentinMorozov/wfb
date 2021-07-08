<!--  resources/views/entitys/index.blade.php -->

@extends('layouts.app')

@section('menu-forms')
    @if (Auth::check())
        @foreach ($forms as $form)
            @if ($form->isfolder == false)
                <el-menu-item index="fg={{ $form->parent_id }}">{{ $form->name }} </el-menu-item>
            @else
                <el-submenu index="{{ $form->parent_id }}">
                    <template slot="title">{{ $form->name }}</template>
                    @foreach ($form->children as $formchildren)
                        @if ($loop->parent->first)
                            <el-menu-item index="form_id={{ $formchildren->id }}">{{ $formchildren->name }}</el-menu-item>
                        @endif
                    @endforeach
                </el-submenu>
            @endif
        @endforeach
    @endif
@endsection

{{--
            @section('content')

                <div is="app-content">
                    <form-report>
                            <div is="entity-wrap">
                                @include('plants.plantsitems')
                                @if (Auth::check() && Auth::user()->isSuperAdmin())
                                    <form-plant>   </form-plant>
                                    <form-plant-move>   </form-plant-move>
                                @endif
        </form-report>
    </div>
@endsection
--}}

@section('scripts')
    <script src="{{ asset('js/reports.js') }}" defer></script>
    {{--    @if (Auth::check() && Auth::user()->isSuperAdmin())
            <script src="{{ asset('js/adm/plants_adm.js') }}" defer></script>
        @endif
    --}}
@endsection
