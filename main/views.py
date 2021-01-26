from django.contrib import messages
from django.http import HttpResponse, Http404
from django.shortcuts import render, redirect


from main.models import Subject


def index(request):
    text = """<h1>Hello Django !</h1>"""
    return HttpResponse(text)


def list(request):
    data = Subject.objects.order_by("order")
    context = {
        'items': data
    }
    return render(request, 'hello.html', context)


def create(request):
    if request.method == "POST":
        Subject.create_subject(name=request.POST['name'], order=request.POST['order'])
        messages.success(request, 'Create subject successful')
        return redirect('/list/')
    return render(request, 'form.html')


def update(request, subject_id):
    try:
        obj = Subject.objects.get(pk=subject_id)
        if request.method == "POST":
            obj.name = request.POST['name']
            obj.order = request.POST['order']
            obj.save()
            messages.success(request, 'Update subject successful')
            return redirect('/list/')
    except Subject.DoesNotExist:
        raise Http404("Subject does not exist")
    return render(request, 'form.html', {'subject': obj})
