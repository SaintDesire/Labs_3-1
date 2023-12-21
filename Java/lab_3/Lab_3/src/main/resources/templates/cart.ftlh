<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 style="text-align: center">Товары</h1>
    <hr>
    <div class="card-columns">
        <#list  orders as order>
            <a href="/product/${(order.product).id}" class="product-link">
                <div class="card text-white bg-dark my-3 product">
                    <div class="card-top">
                        <form action="/cart/delete/${order.id}" method="post">
                            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-danger m-3">
                                Удалить
                            </button>
                        </form>
                    </div>
                    <img src="/images/${(order.product).previewImageId}"
                         class="card-img-top">
                    <div class="card-body">
                        <h5 class="card-title">${(order.product).title}</h5>
                        <p class="card-text">${(order.product).price} ₽</p>
                    </div>
                    <div class="card-footer">
                        ${(order.product).type}
                    </div>
                </div>
            </a>

        <#else>
            <h1 style="text-align: center">Не найдено</h1>
        </#list>
    </div>
    <#if button??>
    <div class="card-top">
        <form action="/cart/createorders" method="get" >
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-danger m-3">
                Заказать все, что находится в корзине.
            </button>
        </form>
    </div>
    </#if>
</@t.template>