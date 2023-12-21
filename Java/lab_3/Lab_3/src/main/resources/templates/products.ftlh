<#import "blocks/template.ftlh" as t>
<#import "blocks/pager.ftlh" as p>
<@t.template user>
    <h1 style="text-align: center">Поиск товаров</h1><hr>
    <form method="get" action="/">
        <div class="form-row">
            <div class="form-group col-md-2">
                <label for="searchType">Категория</label>
                <select id="searchType" required name="searchType" class="form-control">
                    <option value="Категория">Категория не выбрана</option>
                    <option value="Бургер">Бургер</option>
                    <option value="Стрипсы">Стрипсы</option>
                    <option value="Баскет">Баскет</option>
                    <option value="Напитки">Напитки</option>
                    <option value="Соус">Соус</option>
                </select>
            </div>
            <div class="form-group col-md-10">
                <label for="searchWord">Поиск по объявлениям</label>
                <input type="text" name="searchWord" <#if searchWord??>value="${searchWord}"</#if>< class="form-control"
                       id="searchWord">
            </div>
            <button style="width: 100%; background-color: darkred ; color: white" type="submit" class="btn">Поиск</button>
        </div>
    </form>
    <hr>
    <div class="card-columns">
 <@p.pager url products/>


   <#list products.content as product>
            <a href="/product/${product.id}" class="product-link">
                <div class="card text-white bg-dark my-3 product">
                    <div class="card-top">
                       <#if user.isUser()>
                        <form action="/product/addtocart/${product.id}" method="post">
                            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-danger m-3">
                                В корзину
                            </button>
                        </form>
                        </#if>
                    </div>
                    <img src="/images/${product.previewImageId}"
                         class="card-img-top">
                    <div class="card-body">
                        <h5 class="card-title">${product.title}</h5>
                        <p class="card-text">${product.price} ₽</p>
                    </div>
                    <div class="card-footer">
                        ${product.type}
                    </div>
                </div>
            </a>
        <#else>
            <h1 style="text-align: center">Не найдено</h1>
        </#list>
    </div>
</@t.template>