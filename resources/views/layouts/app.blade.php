<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'WFB') }}</title>

    <!-- Styles -->
    <link href="{{ asset('fonts/font-face.css') }}" rel="stylesheet">

    <link href="{{ asset('css/app.css') }}" rel="stylesheet">
    <link href="{{ asset('css/wfb.css') }}" rel="stylesheet">

    <!--k rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" /> -->
    <!--cursiteurl="{{ preg_split('~://~', url('/'), 2)[1] }}" -->
</head>
<body>
    <div is="root-app" id="app" cursiteurl="/wfb/public"
         csrftoken="{{ csrf_token() }}"
         @if (Auth::check() && Auth::user()->isSuperAdmin()) superadmin={{ Auth::user()->isSuperAdmin() }} @endif>
                <div class="fix_top_left">
                    <nav class="navbar navbar-default">
                        <div class="container">

                            <app-menu>
                                <div class="navbar-header">

                                </div>
                                <div class="collapse navbar-collapse">
                                    <!-- Left Side Of Navbar -->
                                    <ul class="nav navbar-nav">
                                        @if (Auth::check())
                                            <el-menu-item index="param">
                                                <template slot="title">Параметры</template>
                                            </el-menu-item>
                                            <el-submenu index="1">
                                                <template slot="title">Отчеты</template>
                                                @yield('menu-forms')
                                            </el-submenu>
                                        @endif
                                    </ul>
                                    <!-- Right Side Of Navbar -->
                                    <div class="nav navbar-nav navbar-right">

                                        <el-submenu index="2">

                                            <template slot="title">Авторизация</template>

                                            @guest
                                                <el-menu-item index="2-11"><a href="{{ route('login') }}">Вход</a></el-menu-item>
                                                <el-menu-item index="2-12"><a href="{{ route('register') }}">Регистрация</a></el-menu-item>
                                                @else
                                                    <el-menu-item index="2-11">
                                                        <div>
                                                            <a href="{{ route('logout') }}" onclick="event.preventDefault();
                                                                 document.getElementById('logout-form').submit();">
                                                                Выход ({{ Auth::user()->name }})
                                                            </a>

                                                            <form id="logout-form" action="{{ route('logout') }}" method="POST" style="display: none;">
                                                                {{ csrf_field() }}
                                                            </form>
                                                        </div>
                                                    </el-menu-item>

                                                    @endguest
                                        </el-submenu>

                                        <el-menu-item index="3">
                                            <a href="{{ url('/') }}"> {{ config('app.name', 'WFB') }}  </a>
                                        </el-menu-item>

                                    </div>
                                </div>
                            </app-menu>

                        </div>

                    </nav>
                </div>
        <!-- Отступ свурху на высоту области меню -->
                <nav class="navbar navbar-default">
                     <span></span>
                </nav>

                <div is="app-wrap" class="visible_off03">

                        @yield('content')

                </div>
    </div>

<!-- Scripts -->
<script>
    window.AppComponents = {};
    window.AppComponents.Init = [];
</script>
@yield('scripts')
<script src="{{ asset('js/app.js') }} " defer></script>

</body>
</html>
