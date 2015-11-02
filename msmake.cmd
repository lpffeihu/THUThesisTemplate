@rem -*- mode: conf -*-
@rem ----------------------------------------------------------------------
@rem START OF FILE
@rem ----------------------------------------------------------------------
@rem 
@rem Filename: msmake.cmd
@rem Author: Fred Qi
@rem Created: 2006-05-20 14:09:57(+0800)
@rem Version: 
@rem 
@rem ----------------------------------------------------------------------
@rem COMMENTARY
@rem ----------------------------------------------------------------------
@rem
@rem ʹ��˵����
@rem
@rem 1.����thuthesis���
@rem msmake setup
@rem �����ڵ�ǰĿ¼������thuthesis�����˵���ĵ�thuthesis.pdf
@rem
@rem 2.����ʾ���ĵ�
@rem msmake [shuji|main|all|other]
@rem �����ڵ�ǰĿ¼������ʾ���ĵ��������е�һ���֣��������û�ָ���ĵ�
@rem �����ǰĿ¼����thuthesis.cls�����Զ�����thuthesis.ins���ɡ�
@rem ����- shuji	�������鼹
@rem ����- main		������main.pdf
@rem ����- all		�����鼹��main.pdf��Ĭ��ѡ��
@rem ����- other	�û�ָ����tex�ļ������ɸ�tex�ļ�����pdf�ĵ�
@rem
@rem 3.����Ŀ¼
@rem msmake clean [other]
@rem ��������ǰĿ¼����thuthesis������ɵ��ļ����������
@rem �������˵���ĵ�thuthesis.{cls,cfg,dvi,ps,pdf}
@rem ʾ���ĵ�shuji.pdf, main.{dvi,ps,pdf,aux,etc.}
@rem ����û�ָ�������ļ�������ɾ��main.*����ɾ��
@rem other.{dvi,ps,pdf,lo?,aux,bbl,blg,out* toc thm}
@rem
@rem 4.����ͼ��ͼ���ļ���ʽת�����
@rem msmake epspdf [param] 
@rem	 ����ǰĿ¼������eps�ļ���epstopdfתΪpdf��ʽ
@rem msmake bmpeps [param]
@rem	 ����ǰĿ¼������bmp,jpg,png�ļ���bmepsתΪeps��ʽ
@rem �������������У�[param]�������û�ָ��ת���������õĲ�����
@rem 
@rem ----------------------------------------------------------------------
@rem CHANGE LOG
@rem ----------------------------------------------------------------------
@rem Last-Updated: 2006-05-26 11:47:40(+0800) [by Fred Qi@lab]
@rem     Update #: 312
@rem ----------------------------------------------------------------------
@rem 2006-05-20 16:53:38(+0800)    Fred Qi@lab
@rem    msmake.cmd initial. prepaired for thuthesis 2.5
@rem 
@rem 
@rem 
@rem ----------------------------------------------------------------------
@rem ----------------------------------------------------------------------

@echo off
set thupkg=thuthesis
set tmpfile=_clstemptest_
set ltxparam=-quiet -c-style-errors
if /i {%1}=={clean} goto clean
if /i {%1}=={epspdf} goto epspdf
if /i {%1}=={bmpeps} goto bmpeps
if /i {%1}=={setup} goto setup
goto testcls
:clean
@rem =============================================
@rem ����ĵ����ɹ����в�������ʱ�ļ�
@rem =============================================
echo ɾ��thuthesis�������ļ�
del /f /q %thupkg%.cls %thupkg%.cfg 
echo ɾ��thuthesis�����˵���ĵ�
del /f /q %thupkg%.dvi %thupkg%.ps %thupkg%.pdf
echo ɾ��shuji.pdf
del /f /q shuji.pdf shuji.ps shuji.dvi
echo ɾ��ʾ���ĵ�main.pdf�����ɸ��ĵ������в������ļ�
if {%2}=={} (set targ=main) else (set targ=%2)
del /f %targ%.dvi %targ%.ps %targ%.pdf
del /f %targ%.lo? %targ%.aux %targ%.bbl %targ%.blg
del /f %targ%.out* %targ%.toc %targ%.thm
del /f data\*.aux
echo ɾ��������ʱ�ļ�
del /f /q *.log *.aux *.glo *.idx *.ilg *.ind *.out *.thm *.toc *.lot *.loe *.out.bak
goto end
@rem =============================================
@rem ����ǰĿ¼�µ�eps�ļ�ת��Ϊpdf��ʽ
@rem ��Ҫ�õ�epstopdf
@rem =============================================
:epspdf
if /i {%2}=={} (
  set conv=call epstopdf %%i
) else (
  set conv=call epstopdf %2 %%i
)
@echo on
for %%i in (*.eps) do %conv%
@echo off
goto end
@rem =============================================
@rem ����ǰĿ¼�µ�bmp,jpg,pngͼ��ת��Ϊeps��ʽ
@rem ��Ҫ�õ�bmeps
@rem =============================================
:bmpeps
if /i {%2}=={} (set param=-c) else (set param=%2)
set conv=call bmeps %param% %%i %%~ni.eps
@echo on
for %%i in (*.bmp *.jpg *.png) do %conv%
@echo off
goto end
:testcls
@rem =============================================
echo ���ڲ����Ƿ���Ҫ����thuthesis���...
@rem =============================================
if not exist %thupkg%.cls goto presetup
if not exist %thupkg%.cfg goto presetup
goto choose
@rem -----------------------------
@rem this section of code is NOT used.
echo \documentclass{%thupkg%}>%tmpfile%.tex
echo \begin{document}>>%tmpfile%.tex
echo \end{document}>>%tmpfile%.tex
call latex %ltxparam% %tmpfile%.tex>nul
IF ERRORLEVEL 1 (goto presetup) else goto choose
@rem NOT used code block end.
@rem -----------------------------
:presetup
@rem del /f /q %tmpfile%.*
echo ��û�а�װ�����ú�thuthesis�����
echo ��������ͼ�������ɲ�����thuthesis���...
:setup
@rem =============================================
@rem ����thuthesis�����˵���ĵ�
@rem =============================================
if not exist %thupkg%.ins goto clserr4
if exist %thupkg%.cls del /f /q %thupkg%.cls
if exist %thupkg%.cfg del /f /q %thupkg%.cfg
echo ��������%thupkg%���...
call latex %ltxparam% %thupkg%.ins
@rem IF errorlevel 1 goto clserr3
echo �ɹ�����thuthesis���
@rem ----------------------------------------------
if not exist %thupkg%.dtx goto clserr2
echo ��������%thupkg%�����˵���ĵ�...
call latex %ltxparam% %thupkg%.dtx
if errorlevel 1 goto clserr1
call makeindex -s gind.ist -o %thupkg%.ind %thupkg%.idx
if errorlevel 1 goto clserr1
call makeindex -s gglo.ist -o %thupkg%.gls %thupkg%.glo
if errorlevel 1 goto clserr1
call latex %ltxparam% %thupkg%.dtx
if errorlevel 1 goto clserr1
call gbk2uni %thupkg%.out
if errorlevel 1 goto clserr1
call latex %ltxparam% %thupkg%.dtx
if errorlevel 1 goto clserr1
call dvips -Ppdf -G0 %thupkg%.dvi
if errorlevel 1 goto clserr1
call ps2pdf %thupkg%.ps
if errorlevel 1 goto clserr1
echo �ɹ�����thuthesis˵���ĵ�thuthesis.pdf
@rem ����˵���ĵ����ɹ����в�������ʱ�ļ�
del /f /q %thupkg%.log
del /f /q %thupkg%.aux
del /f /q %thupkg%.glo
del /f /q %thupkg%.gls
del /f /q %thupkg%.idx
del /f /q %thupkg%.out
del /f /q %thupkg%.out.bak
del /f /q %thupkg%.ind
del /f /q %thupkg%.ilg
del /f /q %thupkg%.toc
@rem del /f /q %thupkg%.dvi
@rem del /f /q %thupkg%.ps
goto choose
@rem ----------------------------------------------
:clserr2
echo û���ҵ�thuthesis.dtx�ļ�
:clserr1
echo �޷�����˵���ĵ�thuthesis.pdf
goto end
:clserr4
echo û���ҵ�thuthesis.ins�ļ�
:clserr3
echo �޷�����thuthesis���
goto end
:choose
if /i {%1}=={setup} goto end
set ltx=latex %ltxparam%
if /i {%1}=={shuji} goto shuji
if /i {%1}=={main} goto main
if /i {%1}=={all} goto all
if /i {%1}=={} (goto all) else goto other
:dvips
@rem =============================================
@rem ʹ��latex->dvips->ps2pdf����ʾ���ĵ�main.pdf
@rem =============================================
:other
set targ=%2
goto latex
:all
:shuji
set targ=shuji
set errmsg=pdflatex
call pdflatex shuji.tex
if errorlevel 1 goto error
@rem set errmsg=dvipdfmx
@rem dvipdfmx shuji.dvi
@rem if errorlevel 1 goto error
del /f /q %targ%.aux
del /f /q %targ%.log
del /f /q %targ%.out
del /f /q %targ%.thm
@rem del /f /q %targ%.dvi
if /i {%1}=={shuji} goto end
:main
set targ=main
goto latex
:pdf
@rem =============================================
@rem ʹ��pdflatex����ʾ���ĵ�main.pdf
@rem =============================================
@echo δʵ�ֵĹ��ܡ�
goto end
:latex
@rem =============================================
@rem ����ʾ���ĵ�
@rem =============================================
set errmsg=%ltx%
call %ltx% %targ%
if errorlevel 1 goto error
set errmsg=bibtex
call bibtex -quiet %targ%
if errorlevel 1 goto error
set errmsg=latex
call %ltx% %targ%
if errorlevel 1 goto error
set errmsg=gbk2uni
call gbk2uni %targ%
if errorlevel 1 goto error
set errmsg=latex
call %ltx% %targ%
if errorlevel 1 goto error
if {%1}=={pdf} goto end
set errmsg=dvips
call dvips -Ppdf -G0 -ta4 %targ%.dvi
if errorlevel 1 goto error
set errmsg=ps2pdf
call ps2pdf %targ%.ps
if errorlevel 1 goto error
goto end
@rem =============================================
@rem ʾ���ļ����ɹ����г�����
@rem =============================================
:error
echo ʹ��%errmsg%����%targ%.pdf�Ĺ����г���
:end
@rem =============================================
@rem ִ�н���
@rem =============================================
@rem ----------------------------------------------------------------------
@rem END OF FILE
@rem ----------------------------------------------------------------------
